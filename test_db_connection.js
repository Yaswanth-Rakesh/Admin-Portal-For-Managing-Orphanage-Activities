const mysql = require('mysql2/promise');
require('dotenv').config();

async function testDatabase() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || "localhost",
      user: process.env.DB_USER || "root",
      password: process.env.DB_PASSWORD || "",
      database: process.env.DB_NAME || "smart_orphanage",
      port: process.env.DB_PORT || 3306,
    });

    console.log("✅ Database connected successfully!");

    // Test staff_attendance_complaints table structure
    const [complaintsStructure] = await connection.execute("DESCRIBE staff_attendance_complaints");
    console.log("\n📋 staff_attendance_complaints table structure:");
    complaintsStructure.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : ''} ${col.Key || ''}`);
    });

    // Test attendance table structure
    const [attendanceStructure] = await connection.execute("DESCRIBE attendance");
    console.log("\n📋 attendance table structure:");
    attendanceStructure.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : ''} ${col.Key || ''}`);
    });

    // Test users table structure
    const [usersStructure] = await connection.execute("DESCRIBE users");
    console.log("\n📋 users table structure:");
    usersStructure.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : ''} ${col.Key || ''}`);
    });

    // Check if there are any staff users
    const [staffUsers] = await connection.execute("SELECT id, name, email, role FROM users WHERE role = 'staff' LIMIT 5");
    console.log("\n👥 Staff users:");
    staffUsers.forEach(user => {
      console.log(`  ID: ${user.id}, Name: ${user.name}, Email: ${user.email}, Role: ${user.role}`);
    });

    // Check if there are any attendance records
    const [attendanceRecords] = await connection.execute("SELECT id, staff_id, date, status FROM attendance LIMIT 5");
    console.log("\n📅 Attendance records:");
    attendanceRecords.forEach(record => {
      console.log(`  ID: ${record.id}, Staff ID: ${record.staff_id}, Date: ${record.date}, Status: ${record.status}`);
    });

    // Check if there are any complaints
    const [complaints] = await connection.execute("SELECT id, staff_id, attendance_id, status FROM staff_attendance_complaints LIMIT 5");
    console.log("\n📝 Complaints:");
    complaints.forEach(complaint => {
      console.log(`  ID: ${complaint.id}, Staff ID: ${complaint.staff_id}, Attendance ID: ${complaint.attendance_id}, Status: ${complaint.status}`);
    });

    await connection.end();
  } catch (error) {
    console.error("❌ Database test failed:", error.message);
  }
}

testDatabase();
