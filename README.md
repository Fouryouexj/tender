# IMOTH TENDERS TRACKER
## Kenya Public Procurement Tender Management System

A full-stack web application for tracking, managing, and collaborating on government tenders.

---

## 📦 What's Included

- **Backend**: Node.js/Express API
- **Frontend**: Interactive HTML5 SPA
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Authentication
- **Real-time**: Live tender updates across users

---

## 🚀 Quick Start (Local Development)

### 1. Prerequisites
- Node.js 16+
- npm (comes with Node)
- Supabase account (free tier available)

### 2. Install & Run
```bash
npm install
npm run dev  # Runs on http://localhost:3000
```

### 3. Open Frontend
```
file:///[your-path]/imoth_tenders_patched.html
```

Or:
```
http://localhost:8888/imoth_tenders_patched.html
```

---

## 📚 Deployment Guides

### Quick Deployment (25 mins)
👉 **[Read QUICK_DEPLOY.md](./QUICK_DEPLOY.md)**

Step-by-step guide to get your app live on DigitalOcean in 30 minutes.

### Detailed Deployment (Reference)
👉 **[Read DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)**

Comprehensive guide covering all deployment options, troubleshooting, and advanced setup.

---

## 🔧 Configuration

### Environment Variables
Create a `.env` file (copy from `.env.example`):

```bash
cp .env.example .env
```

Then update with your Supabase credentials:

| Variable | Where to Find |
|----------|---------------|
| `SUPABASE_URL` | Supabase Dashboard → Settings → API |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase Dashboard → Settings → API (scroll down) |
| `NODE_ENV` | Set to `production` on DigitalOcean |
| `PORT` | Usually `3000` (DigitalOcean uses this) |

---

## 📡 API Documentation

### Endpoints

#### Health Check
```http
GET /health
```
Response: `{"status":"ok"}`

#### User Signup
```http
POST /api/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123",
  "full_name": "John Doe",
  "role": "user"
}
```

Response:
```json
{
  "success": true,
  "message": "User John Doe created successfully",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "full_name": "John Doe"
  }
}
```

---

## 👥 User Roles

### Admin
- Create and manage user accounts
- See all tenders
- See all team members and their assignments
- View complete audit trail
- Assign tenders to team members

### Marketer
- View all tenders
- Edit tender details (notes, status, etc.)
- See own assigned tenders
- See other team members
- Filter by own assignments

---

## 🔐 Security

✅ **What We Do Right:**
- Service role key stored server-side only
- CORS restricted to your domain
- Passwords hashed by Supabase
- Row-level security on database
- No sensitive data in frontend code
- HTTPS only on production

✅ **Best Practices:**
- Never commit `.env` to Git
- Use strong passwords (min 6 chars)
- Regularly update npm packages
- Monitor audit logs
- Enable backups

---

## 🗄️ Database

### Tables
- **tenders** - All tender records
- **profiles** - User accounts and roles
- **audit_log** - Change history

### Setup
Supabase setup SQL is in `supabase_setup.sql`. Run it once in Supabase SQL Editor.

---

## 🐛 Troubleshooting

### Development Issues

**"Cannot find module 'express'"**
```bash
npm install
```

**Port 3000 already in use**
```bash
PORT=3001 npm run dev
```

**CORS errors in browser**
- Check that `FRONTEND_URL` matches your origin
- Verify server is running on the correct port

### Deployment Issues

**"Connection refused to Supabase"**
- Verify `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`
- Check Supabase project is not paused
- Try regenerating the key

**App won't start on DigitalOcean**
- Check Runtime logs for error messages
- Verify all env vars are set
- Try restarting the app

👉 **See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for more troubleshooting**

---

## 📋 Project Structure

```
imoth_tenders_patched.html    # Frontend SPA
server.js                      # Backend API
package.json                   # Dependencies
.env                          # Configuration (not in Git)
.env.example                  # Template for .env
supabase_setup.sql           # Database schema
DEPLOYMENT_GUIDE.md          # Full deployment docs
QUICK_DEPLOY.md              # Quick start deployment
```

---

## 🚢 Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] DigitalOcean account created
- [ ] Environment variables set correctly
- [ ] Supabase database configured
- [ ] App deployed successfully
- [ ] Test user creation works
- [ ] Browse tenders works
- [ ] Audit log shows changes
- [ ] Custom domain added (optional)

---

## 📞 Support

### Resources
- [DigitalOcean Docs](https://docs.digitalocean.com)
- [Supabase Docs](https://supabase.com/docs)
- [Express.js Docs](https://expressjs.com)
- [Node.js Docs](https://nodejs.org/docs)

### Logs
- **Local**: Terminal where `npm run dev` is running
- **Production**: DigitalOcean App Platform → Runtime logs

---

## 📝 License

This project is proprietary software for IMOTH Insurance Brokers.

---

## 🤝 Team

Built with ❤️ for Kenya's public procurement process.

**Ready to deploy?** → Start with [QUICK_DEPLOY.md](./QUICK_DEPLOY.md)
