package com.megacitycab.dao;

import com.megacitycab.auth.Users;
import jakarta.persistence.NoResultException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

public class UserDAO {
    private static final SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();

    public Users findByUsername(String username) {
        try (Session session = sessionFactory.openSession()) {
            Query<Users> query = session.createQuery("FROM Users WHERE username = :username", Users.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }
}
