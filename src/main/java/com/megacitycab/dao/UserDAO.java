package com.megacitycab.dao;

import com.megacitycab.auth.Users;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
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
