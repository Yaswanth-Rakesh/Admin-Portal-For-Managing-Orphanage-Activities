-- Smart Orphanage Database Setup
-- This file creates all necessary tables for the staff and donor dashboards

-- Users table (for authentication)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff', 'user') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Staff table (for staff management)
CREATE TABLE IF NOT EXISTS staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    role VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Donors table (for donor management)
CREATE TABLE IF NOT EXISTS donors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Donations table (for tracking donations)
CREATE TABLE IF NOT EXISTS donations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    donation_date DATE NOT NULL,
    purpose TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE
);

-- Staff attendance table (for tracking staff attendance)
CREATE TABLE IF NOT EXISTS staff_attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE
);

-- Complaints table (for donor complaints about donations)
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    donation_id INT NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Resolved', 'Dismissed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE,
    FOREIGN KEY (donation_id) REFERENCES donations(id) ON DELETE CASCADE
);

-- Staff attendance complaints table (for staff complaints about attendance)
CREATE TABLE IF NOT EXISTS staff_attendance_complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    attendance_id INT NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Resolved', 'Dismissed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE,
    FOREIGN KEY (attendance_id) REFERENCES staff_attendance(id) ON DELETE CASCADE
);

-- Children table (for orphanage children)
CREATE TABLE IF NOT EXISTS children (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    admission_date DATE NOT NULL,
    joined_by VARCHAR(255),
    mobile_number VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical records table
CREATE TABLE IF NOT EXISTS medical_records (
    id VARCHAR(36) PRIMARY KEY,
    child_id VARCHAR(36) NOT NULL,
    medical_date DATE NOT NULL,
    medical_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE
);

-- Education records table
CREATE TABLE IF NOT EXISTS education_records (
    id VARCHAR(36) PRIMARY KEY,
    child_id VARCHAR(36) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    education_level VARCHAR(100) NOT NULL,
    school VARCHAR(255) NOT NULL,
    performance TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE
);

-- Sponsor records table
CREATE TABLE IF NOT EXISTS sponsor_records (
    id VARCHAR(36) PRIMARY KEY,
    child_id VARCHAR(36) NOT NULL,
    sponsor_type VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE
);

-- Attendance table (general attendance)
CREATE TABLE IF NOT EXISTS attendance (
    id VARCHAR(36) PRIMARY KEY,
    staff_id VARCHAR(36) NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory table
CREATE TABLE IF NOT EXISTS inventory (
    id VARCHAR(36) PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    item VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    min_stock INT NOT NULL,
    supplier VARCHAR(255),
    notes TEXT,
    last_updated DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events table
CREATE TABLE IF NOT EXISTS events (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue VARCHAR(255) NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reports table
CREATE TABLE IF NOT EXISTS reports (
    id VARCHAR(36) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    notes TEXT NOT NULL,
    author VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Password reset tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_staff_email ON staff(email);
CREATE INDEX idx_donors_email ON donors(email);
CREATE INDEX idx_donations_donor_id ON donations(donor_id);
CREATE INDEX idx_donations_date ON donations(donation_date);
CREATE INDEX idx_staff_attendance_staff_id ON staff_attendance(staff_id);
CREATE INDEX idx_staff_attendance_date ON staff_attendance(date);
CREATE INDEX idx_complaints_donor_id ON complaints(donor_id);
CREATE INDEX idx_complaints_donation_id ON complaints(donation_id);
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_staff_attendance_complaints_staff_id ON staff_attendance_complaints(staff_id);
CREATE INDEX idx_staff_attendance_complaints_attendance_id ON staff_attendance_complaints(attendance_id);
CREATE INDEX idx_children_admission_date ON children(admission_date);
CREATE INDEX idx_medical_records_child_id ON medical_records(child_id);
CREATE INDEX idx_education_records_child_id ON education_records(child_id);
CREATE INDEX idx_sponsor_records_child_id ON sponsor_records(child_id);
CREATE INDEX idx_inventory_category ON inventory(category);
CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_reports_category ON reports(category);
CREATE INDEX idx_password_reset_tokens_email ON password_reset_tokens(email);
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);

-- Insert sample data for testing

-- Sample admin user
INSERT IGNORE INTO users (name, email, password, role) VALUES 
('Admin User', 'admin@orphanage.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Sample staff user
INSERT IGNORE INTO users (name, email, password, role) VALUES 
('Staff User', 'staff@orphanage.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff');

-- Sample donor user
INSERT IGNORE INTO users (name, email, password, role) VALUES 
('Donor User', 'donor@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');

-- Sample staff member
INSERT IGNORE INTO staff (name, email, phone, role) VALUES 
('John Smith', 'staff@orphanage.com', '+1234567890', 'Caregiver');

-- Sample donor
INSERT IGNORE INTO donors (name, email, phone, address) VALUES 
('Jane Doe', 'donor@example.com', '+0987654321', '123 Main St, City, State');

-- Sample donation
INSERT IGNORE INTO donations (donor_id, amount, donation_date, purpose) VALUES 
(1, 1000.00, '2024-01-15', 'General donation for children');

-- Sample staff attendance
INSERT IGNORE INTO staff_attendance (staff_id, date, status) VALUES 
(1, '2024-01-15', 'Present'),
(1, '2024-01-16', 'Present'),
(1, '2024-01-17', 'Absent');

-- Sample children
INSERT IGNORE INTO children (id, name, dob, gender, admission_date, joined_by, mobile_number, notes) VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Alice Johnson', '2015-03-15', 'Female', '2020-01-10', 'Social Worker', '+1234567890', 'Loves reading'),
('550e8400-e29b-41d4-a716-446655440002', 'Bob Wilson', '2016-07-22', 'Male', '2020-02-15', 'Police', '+1234567891', 'Enjoys sports');

-- Sample medical records
INSERT IGNORE INTO medical_records (id, child_id, medical_date, medical_type, description, notes) VALUES 
('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', '2024-01-10', 'Checkup', 'Annual health checkup', 'All normal'),
('550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', '2024-01-12', 'Vaccination', 'Flu shot', 'No adverse reactions');

-- Sample education records
INSERT IGNORE INTO education_records (id, child_id, academic_year, education_level, school, performance, notes) VALUES 
('550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', '2023-2024', 'Grade 3', 'Local Elementary School', 'Excellent', 'Top of class'),
('550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440002', '2023-2024', 'Grade 2', 'Local Elementary School', 'Good', 'Improving in math');

-- Sample inventory
INSERT IGNORE INTO inventory (id, category, item, quantity, min_stock, supplier, notes) VALUES 
('550e8400-e29b-41d4-a716-446655440007', 'Food', 'Rice', 50, 10, 'Local Market', 'Basmati rice'),
('550e8400-e29b-41d4-a716-446655440008', 'Clothing', 'School Uniforms', 25, 5, 'Uniform Store', 'Size 6-12');

-- Sample events
INSERT IGNORE INTO events (id, name, date, time, venue, status, description) VALUES 
('550e8400-e29b-41d4-a716-446655440009', 'Annual Sports Day', '2024-06-15', '09:00:00', 'Orphanage Grounds', 'Scheduled', 'Annual sports competition for children'),
('550e8400-e29b-41d4-a716-446655440010', 'Christmas Party', '2024-12-25', '14:00:00', 'Main Hall', 'Scheduled', 'Christmas celebration with gifts');

-- Sample reports
INSERT IGNORE INTO reports (id, title, category, date, notes, author) VALUES 
('550e8400-e29b-41d4-a716-446655440011', 'Monthly Financial Report', 'Financial', '2024-01-31', 'Monthly financial summary and budget analysis', 'Admin User'),
('550e8400-e29b-41d4-a716-446655440012', 'Children Health Report', 'Health', '2024-01-31', 'Monthly health checkup summary', 'Dr. Smith');

COMMIT; 