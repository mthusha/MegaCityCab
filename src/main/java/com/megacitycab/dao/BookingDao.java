package com.megacitycab.dao;

import com.megacitycab.model.Booking;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class BookingDao {

    private static BookingDao instance;
    private BookingDao() {}

    public void save(Booking booking) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(booking);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
//            e.printStackTrace();
            throw new RuntimeException("Failed to save booking");
        }
    }

    public static BookingDao getInstance() {
        if (instance == null) {
            synchronized (UserDao.class) {
                if (instance == null) {
                    instance = new BookingDao();
                }
            }
        }
        return instance;
    }

}
