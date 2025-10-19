-- Fix foreign key constraints for staff_attendance_complaints table
-- Drop existing foreign key constraints
ALTER TABLE staff_attendance_complaints 
DROP FOREIGN KEY IF EXISTS staff_attendance_complaints_ibfk_1,
DROP FOREIGN KEY IF EXISTS staff_attendance_complaints_ibfk_2;

-- Add correct foreign key constraints
ALTER TABLE staff_attendance_complaints 
ADD CONSTRAINT fk_staff_attendance_complaints_staff_id 
FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE staff_attendance_complaints 
ADD CONSTRAINT fk_staff_attendance_complaints_attendance_id 
FOREIGN KEY (attendance_id) REFERENCES attendance(id) ON DELETE CASCADE;
