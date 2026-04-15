# 🚀 IMOTH TENDERS — DigitalOcean Deployment Guide

## Overview
Your app consists of:
- **Backend**: Node.js/Express server (handles user signup & API)
- **Frontend**: HTML file (access via browser)
- **Database**: Supabase (cloud, no setup needed)

---

## Step 1: Prepare Code for GitHub

### 1.1 Initialize Git (if not already done)
```bash
cd /home/kret/Downloads/gav
git init
git add .
git commit -m "Initial commit: IMOTH Tenders app"
```

### 1.2 Create `.gitignore`
```bash
echo "node_modules/
.env
.DS_Store
" > .gitignore
git add .gitignore
git commit -m "Add gitignore"
```

### 1.3 Push to GitHub
```bash
# Create a new repository on GitHub (https://github.com/new)
# Then run these commands:
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/imoth-tenders.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username and repo name.

---

## Step 2: Deploy to DigitalOcean App Platform (Recommended)

### 2.1 Create a DigitalOcean Account
- Go to: https://www.digitalocean.com
- Sign up and add a payment method

### 2.2 Create App Platform Project
1. Go to: **Apps** (in left sidebar)
2. Click **Create App**
3. Select **GitHub** as source
4. Authorize DigitalOcean to access your GitHub
5. Select your `imoth-tenders` repository
6. Select branch: `main`
7. Click **Next**

### 2.3 Configure the App

#### Backend Service
The system should auto-detect your Node.js app. Configure it:

**Name**: `imoth-tenders-backend`

**HTTP Port**: `3000`

**Build Command**:
```bash
npm install
```

**Run Command**:
```bash
npm start
```

#### Frontend Service (Optional but Recommended)
To serve the HTML file directly from your backend, we'll add a static file route.

Edit `server.js` and add this BEFORE the signup endpoint:
```javascript
// Serve static files (frontend HTML)
import path from 'path';
import { fileURLToPath } from 'url';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.use(express.static(__dirname));
```

Then you can access the app at: `https://your-app.ondigitalocean.app/imoth_tenders_patched.html`

### 2.4 Set Environment Variables

In the **Environment** section, add:

| Variable | Value | Example |
|----------|-------|---------|
| `SUPABASE_URL` | Your Supabase project URL | `https://your-project.supabase.co` |
| `SUPABASE_SERVICE_ROLE_KEY` | Your service role key from Supabase | `sb_secret_XXXXXXXXXXXXXXXXXXXX` |
| `FRONTEND_URL` | Your deployed URL | `https://imoth-tenders.ondigitalocean.app` |
| `NODE_ENV` | `production` | `production` |
| `PORT` | `3000` | `3000` |

### 2.5 Configure CORS in Backend

Update `server.js` CORS to accept your DigitalOcean domain:

```javascript
app.use(cors({
  origin: (origin, callback) => {
    const allowedOrigins = [
      'http://localhost:8888',
      'http://127.0.0.1:8888',
      'https://imoth-tenders.ondigitalocean.app',
      'https://your-custom-domain.com'  // If you use a custom domain
    ];
    
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('CORS not allowed'));
    }
  },
  credentials: true
}));
```

Commit and push this change to GitHub:
```bash
git add server.js
git commit -m "Update CORS for DigitalOcean deployment"
git push
```

### 2.6 Deploy

1. Click **Create Resource** → **App**
2. Review the configuration
3. Click **Deploy**
4. Wait for deployment to complete (usually 2-5 minutes)

Your app will be live at: `https://imoth-tenders.ondigitalocean.app`

---

## Step 3: Configure Custom Domain (Optional)

### In DigitalOcean:
1. Go to your App
2. Click **Settings**
3. Scroll to **Domains**
4. Click **Add Domain**
5. Enter your domain (e.g., `imoth.yourdomain.com`)

### In your Domain Registrar:
1. Go to DNS settings
2. Add a **CNAME** record:
   - Name: `imoth`
   - Value: `imoth-tenders.ondigitalocean.app`

Let it propagate (usually 24 hours).

---

## Step 4: Verify Database Setup

Before your first user signup:

1. Log into **Supabase Dashboard**
2. Run the SQL setup script:
   - Go to SQL Editor → New query
   - Copy contents of `supabase_setup.sql`
   - Execute
3. Disable email confirmation (optional for smooth signup):
   - Go to **Authentication** → **Providers** → **Email**
   - Toggle OFF "Confirm email" → Save

---

## Step 5: Test the Deployment

### Access the App
```
https://imoth-tenders.ondigitalocean.app/imoth_tenders_patched.html
```

### Test Signup
1. Open the app
2. Create a new user
3. Verify the account is created in Supabase

### Check Logs
In DigitalOcean App Platform:
1. Go to your App
2. Click **Runtime logs**
3. Verify no errors are shown

---

## Step 6: Troubleshooting

### Error: "Service Unavailable"
- Check that all environment variables are set correctly
- Verify Supabase URL and keys are valid
- Check runtime logs

### Error: "Cannot find module"
- Ensure `npm install` ran successfully
- Check that all dependencies in `package.json` are listed
- Restart the app

### CORS Errors
- Add your DigitalOcean domain to the `allowedOrigins` array in `server.js`
- Commit and push the change
- The app will auto-redeploy

### Database Connection Issues
- Verify `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are correct
- Check that Supabase project is active and not paused
- Verify RLS policies allow the operations

---

## Step 7: Set Up Auto-Scaling (Optional)

In DigitalOcean App Platform:
1. Go to your App
2. Click **Settings** → **Auto-scaling**
3. Configure:
   - **Min instances**: 1
   - **Max instances**: 3
   - **CPU threshold**: 70%

This ensures your app scales automatically during high traffic.

---

## Step 8: Backup Strategy

### Database Backups
Supabase handles automatic daily backups. To manual backup:
1. Go to Supabase Dashboard
2. Click **Backups**
3. Click **Create backup now**

### Code Backups
GitHub automatically stores all your code. Always commit important changes.

---

## Step 9: Monitoring & Logs

### View Logs
1. Go to DigitalOcean App Platform → Your App
2. Click **Runtime logs** to see real-time logs
3. Check for errors and warnings

### Metrics
Monitor:
- CPU usage
- Memory usage
- Request count
- Response times

---

## Step 10: Important Notes

### Security
- ✅ Never commit `.env` to GitHub
- ✅ Keep `SUPABASE_SERVICE_ROLE_KEY` secret
- ✅ Use HTTPS only (DigitalOcean provides free SSL)
- ✅ Regularly update dependencies: `npm update`

### Maintenance
- Monitor logs weekly
- Update packages monthly: `npm outdated`
- Test new features in staging before production
- Keep backups of critical data

### Cost Estimate (DigitalOcean App Platform)
- **Starter plan**: $12/month (1GB RAM, 0.25GB storage)
- **Basic plan**: $25/month (1GB RAM, 10GB storage)
- **Supabase**: Free tier (very generous for this use case)

---

## Quick Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] DigitalOcean App created
- [ ] Environment variables set
- [ ] Backend service configured
- [ ] CORS updated for DO domain
- [ ] Database setup in Supabase
- [ ] App deployed successfully
- [ ] Test signup works
- [ ] Custom domain configured (optional)
- [ ] Auto-scaling enabled (optional)
- [ ] Monitoring set up

---

## Need Help?

- **DigitalOcean Docs**: https://docs.digitalocean.com/products/app-platform/
- **Supabase Docs**: https://supabase.com/docs
- **Node.js Docs**: https://nodejs.org/en/docs/

---

**Your app is now live! 🎉**
