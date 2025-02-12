package com.megacitycab.utilities;

import com.megacitycab.model.Customer;
import lombok.Getter;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    @Getter
    private static final SessionFactory sessionFactory;

    static {
        try {
            // Create the SessionFactory from hibernate.cfg.xml
            sessionFactory = new Configuration().configure().buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static void shutdown() {
        getSessionFactory().close();
    }

    public static void main(String[] args) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();

//        Customer customer = new Customer();
//        customer.setName("John Doe");
//        customer.setAddress("123 Main St");
//        customer.setPhone("1234567890");
//        customer.setEmail("john@example.com");

//        session.save(customer);
        transaction.commit();

        session.close();
        HibernateUtil.shutdown();
    }
}
