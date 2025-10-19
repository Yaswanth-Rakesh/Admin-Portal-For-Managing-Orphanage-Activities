const mysql = require('mysql2');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Database connection configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'smart_orphanage',
  multipleStatements: true
};

// Create connection without database first
const connection = mysql.createConnection({
  host: dbConfig.host,
  user: dbConfig.user,
  password: dbConfig.password,
  multipleStatements: true
});

async function setupDatabase() {
  try {
    console.log('🔧 Setting up Smart Orphanage Database...\n');

    // Connect to MySQL
    await new Promise((resolve, reject) => {
      connection.connect((err) => {
        if (err) {
          console.error('❌ Failed to connect to MySQL:', err.message);
          reject(err);
        } else {
          console.log('✅ Connected to MySQL server');
          resolve();
        }
      });
    });

    // Drop database if it exists and recreate it
    await new Promise((resolve, reject) => {
      connection.query(`DROP DATABASE IF EXISTS ${dbConfig.database}`, (err) => {
        if (err) {
          console.error('❌ Failed to drop database:', err.message);
          reject(err);
        } else {
          console.log(`✅ Dropped existing database '${dbConfig.database}'`);
          resolve();
        }
      });
    });

    // Create database
    await new Promise((resolve, reject) => {
      connection.query(`CREATE DATABASE ${dbConfig.database}`, (err) => {
        if (err) {
          console.error('❌ Failed to create database:', err.message);
          reject(err);
        } else {
          console.log(`✅ Database '${dbConfig.database}' created successfully`);
          resolve();
        }
      });
    });

    // Use the database
    await new Promise((resolve, reject) => {
      connection.query(`USE ${dbConfig.database}`, (err) => {
        if (err) {
          console.error('❌ Failed to use database:', err.message);
          reject(err);
        } else {
          console.log(`✅ Using database '${dbConfig.database}'`);
          resolve();
        }
      });
    });

    // Read and execute the SQL setup file
    const sqlFile = path.join(__dirname, 'setup_database.sql');
    if (!fs.existsSync(sqlFile)) {
      throw new Error('setup_database.sql file not found');
    }

    const sqlContent = fs.readFileSync(sqlFile, 'utf8');
    
    await new Promise((resolve, reject) => {
      connection.query(sqlContent, (err, results) => {
        if (err) {
          console.error('❌ Failed to execute SQL setup:', err.message);
          reject(err);
        } else {
          console.log('✅ Database tables created successfully');
          resolve();
        }
      });
    });

    console.log('\n🎉 Database setup completed successfully!');
    console.log('\n📋 Default login credentials:');
    console.log('Admin: admin@orphanage.com / password');
    console.log('Staff: staff@orphanage.com / password');
    console.log('Donor: donor@example.com / password');
    console.log('\n🚀 You can now start the server with: npm start');

  } catch (error) {
    console.error('❌ Database setup failed:', error.message);
    process.exit(1);
  } finally {
    connection.end();
  }
}

// Run the setup
setupDatabase(); 