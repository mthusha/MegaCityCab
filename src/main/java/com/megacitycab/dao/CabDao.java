package com.megacitycab.dao;
import com.megacitycab.model.Cabs;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class CabDao {
    private static CabDao instance;

    private CabDao() {}

    public List<Cabs> getAvailableCabs(LocalDateTime dateTime) {
        List<Cabs> cabs = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql;
            Query<Cabs> query;

            if (dateTime == null) {
                sql = "SELECT * FROM Cabs WHERE status = 'AVAILABLE'";
                query = session.createNativeQuery(sql, Cabs.class);
            } else {
                sql = "SELECT c.* FROM Cabs c " +
                        "WHERE c.status = 'AVAILABLE' " +
                        "AND NOT EXISTS (" +
                        "    SELECT b.* FROM Booking b " +
                        "    WHERE b.cab_id = c.id " +
                        "    AND b.status NOT IN ('CANCELLED', 'COMPLETED') " +
                        "    AND :dateTime BETWEEN b.bookingDateTime " +
                        "    AND DATE_ADD(b.bookingDateTime, INTERVAL b.duration MINUTE)" +
                        ")";

                query = session.createNativeQuery(sql, Cabs.class);
                query.setParameter("dateTime", Timestamp.valueOf(dateTime));

            }

            cabs = query.getResultList();
        } catch (Exception e) {
            System.err.println(e.getMessage());
            //e.printStackTrace();
            throw e;
        }
        return cabs;
    }


    public Cabs findCabById(Long cabId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Cabs.class, cabId);
        }
    }



    public static CabDao getInstance() {
        if (instance == null) {
            synchronized (CabDao.class) {
                if (instance == null) {
                    instance = new CabDao();
                }
            }
        }
        return instance;
    }
}
