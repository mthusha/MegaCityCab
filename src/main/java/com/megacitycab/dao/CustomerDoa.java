package com.megacitycab.dao;

import com.megacitycab.model.Customer;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

public class CustomerDoa {

    private static CustomerDoa instance;


    public Customer findCustomerById(Long customerId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Customer.class, customerId);
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

    public static CustomerDoa getInstance() {
        if (instance == null) {
            synchronized (CustomerDoa.class) {
                if (instance == null) {
                    instance = new CustomerDoa();
                }
            }
        }
        return instance;
    }
}
