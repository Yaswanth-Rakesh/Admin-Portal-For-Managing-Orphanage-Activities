@echo off
echo ========================================
echo    Smart Orphanage System - Quick Start
echo ========================================
echo.

echo [1/4] Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js is installed

echo.
echo [2/4] Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)
echo ✅ Dependencies installed

echo.
echo [3/4] Checking MySQL connection...
echo Please ensure MySQL is running and create a .env file with your database credentials.
echo.
echo Example .env file content:
echo DB_HOST=localhost
echo DB_USER=root
echo DB_PASSWORD=your_password_here
echo DB_NAME=smart_orphanage
echo JWT_SECRET=your_secret_key_here
echo PORT=5001
echo.

set /p choice="Do you want to run the database setup now? (y/n): "
if /i "%choice%"=="y" (
    echo Running database setup...
    npm run setup
    if %errorlevel% neq 0 (
        echo WARNING: Database setup failed. Please check your MySQL connection.
        echo You can still start the server and test the frontend.
    )
)

echo.
echo [4/4] Starting the server...
echo.
echo 🚀 Starting Smart Orphanage System...
echo 📍 Server will be available at: http://localhost:5001
echo 🔧 Test page: http://localhost:5001/test_connection.html
echo.
echo Press Ctrl+C to stop the server
echo.

npm start

pause 