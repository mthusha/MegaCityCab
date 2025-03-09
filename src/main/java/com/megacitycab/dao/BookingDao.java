package com.megacitycab.dao;

import com.megacitycab.enums.BookingStatus;
import com.megacitycab.model.Booking;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

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

    public void updateStatus(Long bookingId, String newStatus) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Booking booking = session.get(Booking.class, bookingId);
            if (booking != null) {
                booking.setStatus(BookingStatus.valueOf(newStatus));
                session.update(booking);
                transaction.commit();
            } else {
                throw new RuntimeException("Booking not found");
            }
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Failed to update booking status");
        }
    }

    public List<Booking> findAll() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<Booking> query = session.createQuery("FROM Booking", Booking.class);
            List<Booking> bookings = query.getResultList();
            transaction.commit();
            return bookings;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Failed to fetch all bookings");
        }
    }

    public void deleteBooking(Long bookingId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Booking booking = session.get(Booking.class, bookingId);
            if (booking != null) {
                session.remove(booking);
            } else {
                throw new RuntimeException("Booking with ID " + bookingId + " not found");
            }
            tx.commit();
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete booking", e);
        }
    }


    public static BookingDao getInstance() {
        if (instance == null) {
            synchronized (UserDAO.class) {
                if (instance == null) {
                    instance = new BookingDao();
                }
            }
        }
        return instance;
    }

    public List<Booking> getAllBookings() {
        return findAll();
    }
}
