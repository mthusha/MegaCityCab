package com.megacitycab.dao;

import com.megacitycab.model.Bill;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class BillDao {

    private static BillDao instance;

    private BillDao() {}

    public static BillDao getInstance() {
        if (instance == null) {
            instance = new BillDao();
        }
        return instance;
    }

    public void save(Bill bill) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(bill);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to save Bill: " + bill.toString(), e);
        }
    }
    public Bill findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Bill.class, id);
        }
    }

    public void update(Bill bill) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.update(bill);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to update Bill: " + bill.toString(), e);
        }
    }

    public List<Bill> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Bill", Bill.class).list();
        }
    }
}
