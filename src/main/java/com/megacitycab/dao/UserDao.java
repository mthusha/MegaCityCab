package com.megacitycab.dao;

import com.megacitycab.auth.Users;
import com.megacitycab.utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

public class UserDao {

    private static UserDao instance;
//    private static final SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();

    private UserDao() {}

    public Users findByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession())  {
            Query<Users> query = session.createQuery("FROM Users WHERE username = :username", Users.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public static UserDao getInstance() {
        if (instance == null) {
            synchronized (UserDao.class) {
                if (instance == null) {
                    instance = new UserDao();
                }
            }
        }
        return instance;
    }

}
