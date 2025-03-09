package com.megacitycab.dao;
import com.megacitycab.enums.BookingStatus;
import com.megacitycab.enums.CabStatus;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Customer;
import com.megacitycab.utilities.HibernateUtil;
import jakarta.transaction.Transactional;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
@Transactional
public class CabDao {
    private static CabDao instance;

    private CabDao() {}


    public void save(Cabs cabs) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(cabs);
            transaction.commit();
        }catch (Exception e) {
            throw new RuntimeException("Failed to save Customer" + cabs.toString(), e);
        }
    }

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

    public List<Cabs> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Cabs> query = session.createQuery("FROM Cabs", Cabs.class);
            return query.list();
        }
    }

    public Cabs findCabById(Long cabId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Cabs.class, cabId);
        }
    }

    public void delete(Long cabId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Cabs cabs = session.get(Cabs.class, cabId);
            if (cabs != null) {
                session.remove(cabs);
            } else {
                throw new RuntimeException("cabs with ID " + cabId + " not found");
            }
            tx.commit();
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete cabs", e);
        }
    }

    public void updateStatus(Long capsId, String newStatus) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                Cabs caps = session.get(Cabs.class, capsId);
                if (caps != null) {
                    caps.setStatus(CabStatus.valueOf(newStatus));
                    session.update(caps);
                    transaction.commit();
                } else {
                    throw new RuntimeException("Cabs not found");
                }
            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw new RuntimeException("Failed to update cabs status", e);
            }
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

    public List<Cabs> getAllCabs() {
        return new ArrayList<>();
    }
}
