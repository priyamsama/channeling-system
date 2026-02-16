-- =====================================================
-- Consultancy Channeling System - Database Schema
-- Database: MySQL 8+
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- 1. Patient Table
-- =========================
CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 2. Doctor Table
-- =========================
CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 3. Channeling Centre
-- =========================
CREATE TABLE channeling_centre (
    centre_id INT AUTO_INCREMENT PRIMARY KEY,
    centre_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 4. Doctor Schedule
-- =========================
CREATE TABLE doctor_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    centre_id INT NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
    FOREIGN KEY (centre_id) REFERENCES channeling_centre(centre_id)
);

-- =========================
-- 5. Appointment
-- =========================
CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    centre_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('BOOKED', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
    FOREIGN KEY (centre_id) REFERENCES channeling_centre(centre_id)
);

-- =========================
-- 6. Payment
-- =========================
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH', 'CARD', 'ONLINE') NOT NULL,
    payment_status ENUM('PENDING', 'PAID') DEFAULT 'PENDING',
    paid_at TIMESTAMP NULL,

    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
);

-- =========================
-- 7. Lab Test Type
-- =========================
CREATE TABLE lab_test (
    lab_test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2)
);

-- =========================
-- 8. Lab Report
-- =========================
CREATE TABLE lab_report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    lab_test_id INT NOT NULL,
    report_file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (lab_test_id) REFERENCES lab_test(lab_test_id)
);

SET FOREIGN_KEY_CHECKS = 1;
