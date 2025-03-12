package com.megacitycab.dao;

import com.megacitycab.auth.Users;
import com.megacitycab.model.Drivers;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class UserDAO {

    private static UserDAO instance;
//    private static final SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();

    private UserDAO() {}

    public Users findByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession())  {
            Query<Users> query = session.createQuery("FROM Users WHERE username = :username", Users.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }
    public void save(Users users) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(users);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to save users: " + users.toString(), e);
        }
    }

    public static UserDAO getInstance() {
        if (instance == null) {
            synchronized (UserDAO.class) {
                if (instance == null) {
                    instance = new UserDAO();
                }
            }
        }
        return instance;
    }

}
