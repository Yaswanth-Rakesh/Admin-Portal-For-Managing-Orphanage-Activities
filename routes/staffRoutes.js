const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { verifyToken, restrictTo } = require('./middleware'); // Assume middleware for auth

const router = express.Router();

// POST /api/staff - Add a new staff member
router.post('/api/staff', verifyToken, restrictTo('admin'), async (req, res) => {
  try {
    const { name, email, phone, job_title } = req.body;

    // Validate input
    if (!name || !email || !phone || !job_title) {
      return res.status(400).json({ message: 'Name, email, phone, and job title are required' });
    }

    // Check if email already exists
    const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // Generate a default password
    const defaultPassword = Math.random().toString(36).slice(-8);
    const hashedPassword = await bcrypt.hash(defaultPassword, 10);

    // Insert into users table with role='staff'
    const [result] = await db.query(
      'INSERT INTO users (name, email, phone, role, password, job_title) VALUES (?, ?, ?, ?, ?, ?)',
      [name, email, phone, 'staff', hashedPassword, job_title]
    );

    res.status(201).json({ message: 'Staff added successfully', id: result.insertId });
  } catch (err) {
    console.error('Error adding staff:', err.message, err.stack);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// PUT /api/staff/:id - Update a staff member
router.put('/api/staff/:id', verifyToken, restrictTo('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, job_title } = req.body;

    // Validate input
    if (!name || !email || !phone || !job_title) {
      return res.status(400).json({ message: 'Name, email, phone, and job title are required' });
    }

    // Check if email is taken by another user
    const [existing] = await db.query('SELECT id FROM users WHERE email = ? AND id != ?', [email, id]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // Update user in the users table
    const [result] = await db.query(
      'UPDATE users SET name = ?, email = ?, phone = ?, job_title = ? WHERE id = ? AND role = ?',
      [name, email, phone, job_title, id, 'staff']
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Staff member not found' });
    }

    res.json({ message: 'Staff updated successfully' });
  } catch (err) {
    console.error('Error updating staff:', err.message, err.stack);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// GET /api/staff - Fetch all staff members
router.get('/api/staff', verifyToken, restrictTo('admin'), async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, email, phone, job_title FROM users WHERE role = ?', ['staff']);
    res.json(rows);
  } catch (err) {
    console.error('Error fetching staff:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// GET /api/staff/me - Fetch current staff profile
router.get('/api/staff/me', verifyToken, async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, name, email, phone, job_title, role FROM users WHERE id = ? AND role = ?',
      [req.user.id, 'staff']
    );
    if (rows.length === 0) return res.status(404).json({ message: 'Staff not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error('Error fetching profile:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// PUT /api/staff/me - Update current staff profile
router.put('/api/staff/me', verifyToken, async (req, res) => {
  try {
    const { name, email, phone } = req.body;

    // Validate input
    if (!name || !email || !phone) {
      return res.status(400).json({ message: 'Name, email, and phone are required' });
    }

    // Check if email is taken by another user
    const [existing] = await db.query('SELECT id FROM users WHERE email = ? AND id != ?', [email, req.user.id]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // Update user in the users table
    const [result] = await db.query(
      'UPDATE users SET name = ?, email = ?, phone = ? WHERE id = ? AND role = ?',
      [name, email, phone, req.user.id, 'staff']
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Staff member not found' });
    }

    res.json({ message: 'Profile updated successfully' });
  } catch (err) {
    console.error('Error updating profile:', err.message, err.stack);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// DELETE /api/staff/:id - Delete a staff member
router.delete('/api/staff/:id', verifyToken, restrictTo('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await db.query('DELETE FROM users WHERE id = ? AND role = ?', [id, 'staff']);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Staff member not found' });
    }
    res.json({ message: 'Staff deleted successfully' });
  } catch (err) {
    console.error('Error deleting staff:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;