

import express from 'express';
import cors from 'cors';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Get current directory (for ES modules)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize Supabase with SERVICE_ROLE_KEY 
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Middleware
app.use(express.json());
app.use(cors({
  origin: (origin, callback) => {
    // Allow CORS for localhost/127.0.0.1 (both variants)
    const allowedOrigins = [
      'http://localhost:8888',
      'http://127.0.0.1:8888',
      'http://localhost:3000',
      'http://127.0.0.1:3000'
    ];
    
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('CORS not allowed'));
    }
  },
  credentials: true
}));

// Serve static files (frontend HTML and assets)
app.use(express.static(__dirname));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// ══════════════════════════════════════════════════════
//  SIGNUP ENDPOINT
// ══════════════════════════════════════════════════════
app.post('/api/signup', async (req, res) => {
  try {
    const { email, password, full_name, role } = req.body;
    
    console.log('📝 Signup request:', { email, full_name, role, passwordLength: password?.length });

    // Validation
    if (!email || !password || !full_name || !role) {
      console.error('❌ Missing fields:', { email, password: !!password, full_name, role });
      return res.status(400).json({ 
        error: 'Missing required fields: email, password, full_name, role' 
      });
    }

    if (password.length < 6) {
      return res.status(400).json({ 
        error: 'Password must be at least 6 characters' 
      });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ 
        error: 'Invalid email format' 
      });
    }

    // Create user in Supabase Auth (using service role key for full control)
    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      user_metadata: { full_name, role },
      email_confirm: true  // Auto-confirm so they can sign in immediately
    });

    if (error) {
      console.error('❌ Supabase auth error:', error.message, error.status);
      return res.status(400).json({ error: `Auth error: ${error.message}` });
    }
    
    console.log('✅ User created:', data.user.id);

    // Create profile row
    const { error: profileError } = await supabase
      .from('profiles')
      .upsert(
        {
          id: data.user.id,
          email,
          full_name,
          role
        },
        { onConflict: 'id' }
      );

    if (profileError) {
      console.error('Profile error:', profileError);
      return res.status(400).json({ error: profileError.message });
    }

    // Return success (don't send password back)
    res.json({
      success: true,
      message: `User ${full_name} created successfully`,
      user: {
        id: data.user.id,
        email: data.user.email,
        full_name
      }
    });

  } catch (err) {
    console.error('Server error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ══════════════════════════════════════════════════════
//  START SERVER
// ══════════════════════════════════════════════════════
app.listen(PORT, () => {
  console.log(`
  ╔════════════════════════════════════════════════════╗
  ║  IMOTH TENDERS BACKEND                             ║
  ║  Running on http://localhost:${PORT}                     ║
  ║                                        ║
  ║                                     ║
  ║                                ║
  ╚════════════════════════════════════════════════════╝
  `);
});
