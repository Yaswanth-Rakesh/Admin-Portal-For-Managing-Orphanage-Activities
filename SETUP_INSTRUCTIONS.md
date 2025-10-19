# Smart Orphanage System Setup Instructions

## Database Setup

### 1. Create MySQL Database
```sql
CREATE DATABASE smart_orphanage;
USE smart_orphanage;
```

### 2. Set up Environment Variables
Create a `.env` file in the root directory with the following content:
```
DB_HOST=localhost
DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password
DB_NAME=smart_orphanage
JWT_SECRET=your_jwt_secret_key_here
PORT=5001
```

### 3. Run Database Setup Script
Execute the `setup_database.sql` file to create all necessary tables:
```bash
mysql -u your_username -p smart_orphanage < setup_database.sql
```

Or run it directly in MySQL:
```bash
mysql -u your_username -p smart_orphanage
source setup_database.sql;
```

### 4. Install Dependencies
```bash
npm install
```

### 5. Start the Server
```bash
npm start
```

## Default Login Credentials

The setup script creates sample users with the password "password" (hashed):

### Admin Dashboard
- Email: admin@orphanage.com
- Password: password
- Role: admin

### Staff Dashboard
- Email: staff@orphanage.com
- Password: password
- Role: staff

### Donor Dashboard
- Email: donor@example.com
- Password: password
- Role: user

## Database Tables Created

1. **users** - Authentication and user management
2. **staff** - Staff member information
3. **donors** - Donor information
4. **donations** - Donation records
5. **staff_attendance** - Staff attendance tracking
6. **complaints** - Donor complaints about donations
7. **staff_attendance_complaints** - Staff complaints about attendance
8. **children** - Orphanage children records
9. **medical_records** - Children's medical records
10. **education_records** - Children's education records
11. **sponsor_records** - Children's sponsor information
12. **inventory** - Inventory management
13. **events** - Event management
14. **reports** - Report generation
15. **password_reset_tokens** - Password reset functionality

## API Endpoints

### Staff Dashboard APIs
- `GET /api/staff/me` - Get current staff info
- `GET /api/attendance/staff/:staffId` - Get staff attendance
- `POST /api/staff/attendance/complaints` - Submit attendance complaint
- `GET /api/staff/attendance/complaints/me` - Get staff's complaints

### Donor Dashboard APIs
- `GET /api/donors/me` - Get current donor info
- `GET /api/donations/me` - Get donor's donations
- `POST /api/donations/complaints` - Submit donation complaint
- `GET /api/donations/complaints/me` - Get donor's complaints

### Authentication APIs
- `POST /api/admin/login` - Admin login
- `POST /api/staff/login` - Staff login
- `POST /api/user/login` - Donor login
- `GET /api/auth/validate` - Validate JWT token

## Features Implemented

### Staff Dashboard
- ✅ Welcome message with staff name
- ✅ Profile information display
- ✅ Attendance tracking and viewing
- ✅ Report attendance mistakes to admin
- ✅ View complaint status
- ✅ Search and filter functionality

### Donor Dashboard
- ✅ Welcome message with donor name
- ✅ Profile information display
- ✅ Donation history viewing
- ✅ Submit complaints about donations
- ✅ View complaint status
- ✅ Export donations to PDF
- ✅ Search and filter functionality

### Admin Features
- ✅ User management
- ✅ Staff management
- ✅ Donor management
- ✅ Donation management
- ✅ Children records
- ✅ Medical records
- ✅ Education records
- ✅ Inventory management
- ✅ Event management
- ✅ Report generation
- ✅ Complaint management

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Check your `.env` file configuration
   - Ensure MySQL is running
   - Verify database credentials

2. **Tables Not Found**
   - Run the `setup_database.sql` script
   - Check if the database exists

3. **API Endpoints Not Working**
   - Ensure the server is running on port 5001
   - Check browser console for CORS errors
   - Verify JWT token is being sent in requests

4. **Login Issues**
   - Use the default credentials provided above
   - Check if users exist in the database
   - Verify password hashing is working

### Testing the System

1. Start the server: `npm start`
2. Open `http://localhost:5001` in your browser
3. Login with one of the default credentials
4. Test the dashboard functionality

## Security Notes

- Change default passwords in production
- Use a strong JWT secret
- Enable HTTPS in production
- Regularly backup the database
- Implement proper input validation
- Use environment variables for sensitive data 