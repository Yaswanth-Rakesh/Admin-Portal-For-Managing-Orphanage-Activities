const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  const { name, email, password, role } = req.body;

  if (!role || !['admin', 'staff', 'user'].includes(role)) {
    return res.status(400).json({ message: 'Valid role is required (admin, staff, user)' });
  }

  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (results.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    db.query('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)', [name, email, hashedPassword, role], (err, result) => {
      if (err) return res.status(500).json({ message: 'Registration failed' });
      res.status(201).json({ message: 'User registered successfully' });
    });
  });
};

exports.login = (req, res) => {
  const { email, password, role } = req.body;

  if (!role || !['admin', 'staff', 'user'].includes(role)) {
    return res.status(400).json({ message: 'Valid role is required' });
  }

  db.query('SELECT * FROM users WHERE email = ? AND role = ?', [email, role], async (err, results) => {
    if (err || results.length === 0) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    const user = results[0];
    const match = await bcrypt.compare(password, user.password);

    if (!match) return res.status(401).json({ message: 'Incorrect password' });

    const token = jwt.sign({ id: user.id, email: user.email, role: user.role }, process.env.JWT_SECRET || 'SECRET_KEY', { expiresIn: '2h' });
    res.status(200).json({ message: 'Login successful', token });
  });
};

exports.forgotPassword = (req, res) => {
  const { email } = req.body;

  db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (results.length === 0) {
      return res.status(200).json({ message: 'If account exists, a reset link has been sent.' });
    }

    // You can integrate email sending logic here
    return res.status(200).json({ message: 'Password reset email would be sent (mock).' });
  });
};
