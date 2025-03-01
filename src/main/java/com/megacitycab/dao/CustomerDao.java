package com.megacitycab.dao;

import com.megacitycab.model.Booking;
import com.megacitycab.model.Customer;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class CustomerDao {

    private static CustomerDao instance;


    public Customer findCustomerById(Long customerId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Customer.class, customerId);
        }
    }

    public void save(Customer customer) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(customer);
            transaction.commit();
        }catch (Exception e) {
            throw new RuntimeException("Failed to save Customer" + customer.toString(), e);
        }
    }
    public Customer findCustomerByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Customer> query = session.createQuery(
                    "SELECT u.customer FROM Users u WHERE u.username = :username", Customer.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public List<Customer> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Customer> query = session.createQuery("FROM Customer", Customer.class);
            return query.list();
        }
    }
    public void delete(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Customer customer = session.get(Customer.class, id);
            if (customer != null) {
                session.remove(customer);
            } else {
                throw new RuntimeException("Customer with ID " + id + " not found");
            }
            tx.commit();
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete Customer", e);
        }
    }

    public String getCustomerEmailByBookingId(Long bookingId) {
        String email = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT c.email FROM Customer c JOIN c.bookings b WHERE b.id = :bookingId";
            Query<String> query = session.createQuery(hql, String.class);
            query.setParameter("bookingId", bookingId);
            email = query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return email;
    }

    public static CustomerDao getInstance() {
        if (instance == null) {
            synchronized (CustomerDao.class) {
                if (instance == null) {
                    instance = new CustomerDao();
                }
            }
        }
        return instance;
    }
}
