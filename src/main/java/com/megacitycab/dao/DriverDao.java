package com.megacitycab.dao;


import com.megacitycab.enums.DriverStatus;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Drivers;
import com.megacitycab.utilities.HibernateUtil;
import jakarta.transaction.Transactional;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

@Transactional
public class DriverDao {
    private static DriverDao instance;

    private DriverDao() {}

    public static DriverDao getInstance() {
        if (instance == null) {
            synchronized (DriverDao.class) {
                if (instance == null) {
                    instance = new DriverDao();
                }
            }
        }
        return instance;
    }

    public void save(Drivers driver) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(driver);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to save driver: " + driver.toString(), e);
        }
    }

    public List<Drivers> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Drivers> query = session.createQuery("FROM Drivers", Drivers.class);
            return query.list();
        }
    }

    public Drivers findById(Long driverId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Drivers.class, driverId);
        }
    }

    public void update(Drivers driver) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.update(driver);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to update driver", e);
        }
    }

    public void updateStatus(Long driverId, String newStatus) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Drivers driver = session.get(Drivers.class, driverId);
            if (driver != null) {
                driver.setStatus(DriverStatus.valueOf(newStatus));
                session.update(driver);
                transaction.commit();
            } else {
                throw new RuntimeException("Driver not found");
            }
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to update driver status", e);
        }
    }

    public void delete(Long driverId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Drivers driver = session.get(Drivers.class, driverId);
            if (driver != null) {
                if (driver.getCabs() != null) {
                    Cabs cab = driver.getCabs();
                    cab.setDriver(null);
                    session.update(cab);
                }
                session.remove(driver);
                transaction.commit();
            } else {
                throw new RuntimeException("Driver with ID " + driverId + " not found");
            }
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Failed to delete driver", e);
        }
    }

    public List<Drivers> getAvailableDrivers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Drivers> query = session.createQuery(
                    "FROM Drivers d WHERE d.status = 'AVAILABLE' AND d.cabs IS NULL",
                    Drivers.class
            );
            return query.list();
        }
    }

}
