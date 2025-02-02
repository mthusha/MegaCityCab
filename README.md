# Mega City Cab System

## Project Overview

Mega City Cab is a computerized system designed to streamline cab booking operations in Colombo City. The system allows
users to register customers, manage bookings, store driver and vehicle information, generate bills, and provide helpful
system usage guidelines. It replaces the manual method of handling customer orders and details, making the process
efficient and error-free.

## Features

1. **User Authentication**: Secure login system using a username and password.
2. **Customer Booking Management**:
    - Register new customers with details (name, address, NIC, etc.).
    - Record customer bookings with order number, name, destination, and contact details.
3. **View Booking Details**: Retrieve and display customer orders.
4. **Billing System**:
    - Calculate total fare based on distance, time, applicable taxes, and discounts.
    - Print bill receipts for customers.
5. **Car & Driver Management**:
    - Maintain vehicle details (car type, registration number, availability).
    - Store driver details (name, license number, contact information).
6. **Driver Booking Management**:
    - Drivers can view assigned bookings.
    - Drivers can update the status of bookings (e.g., accepted, completed).
    - This feature is free to use.
7. **Help Section**: Provides system usage guidelines for new users.
8. **Exit System**: Allows users to securely log out and close the application.

## Assumptions

- Admin users have full control over adding, updating, and deleting records.
- Customer details and booking records are stored in text files for data persistence.
- Username and password authentication ensures security.
- The fare calculation is based on predefined rates (e.g., per kilometer, waiting charges).
- Only authorized personnel can modify car and driver details.

## Technologies Used

- **Programming Language**: Java
- **Web Application Framework**: Java EE (Servlet & JSP)
- **Database**: MySQL
- **User Interface**: Web-based, menu-driven system
- **Data Structures**: Arrays, ArrayLists, HashMaps for managing records

## Installation & Setup

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/yourusername/mega-city-cab.git
   ```
2. **Compile and Deploy the Application**:
    - Use Apache Tomcat for running the Java EE application.
    - Ensure MySQL is installed and configured.
3. **Run the Application**:
    - Access the system via a web browser after deployment.

## Usage Instructions

1. **Login**: Enter username and password to access the system.
2. **Add Booking**: Select the option to register a new booking and enter customer details.
3. **View Bookings**: Retrieve and display booking details by entering the order number.
4. **Generate Bill**: Select the billing option to calculate and print the fare.
5. **Manage Cars & Drivers**: Admins can update vehicle and driver records.
6. **Manage Driver Bookings**: Drivers can view and update their assigned bookings.
7. **Help**: Access system guidelines for navigation and usage.
8. **Exit**: Properly log out and close the application.

## Error Handling

- Invalid login attempts are restricted after three failed attempts.
- Input validation ensures correct data entry for customer details and bookings.
- Proper error messages are displayed for invalid inputs and missing records.
- Booking numbers are auto-generated to prevent duplicates.

## Future Enhancements

- **Enhanced Database Integration**: Use MySQL for better data management.
- **GUI Development**: Implement a user-friendly graphical interface.
- **Online Booking Portal**: Allow customers to book cabs via a web or mobile app.
- **GPS Tracking**: Integrate real-time tracking for driver and passenger convenience.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

TUZA

