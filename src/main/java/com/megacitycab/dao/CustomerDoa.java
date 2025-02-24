package com.megacitycab.dao;

import com.megacitycab.model.Customer;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;

public class CustomerDoa {

    private static CustomerDoa instance;


    public Customer findCustomerById(Long customerId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Customer.class, customerId);
        }
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
