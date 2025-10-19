-- Create complaints table for the smart_orphanage database
-- This table stores complaints submitted by donors about their donations

CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    donation_id INT NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Resolved', 'Dismissed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional: Add indexes for better performance
CREATE INDEX idx_complaints_donor_id ON complaints(donor_id);
CREATE INDEX idx_complaints_donation_id ON complaints(donation_id);
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_complaints_created_at ON complaints(created_at); 