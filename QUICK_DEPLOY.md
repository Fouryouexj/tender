# 🚀 QUICK DEPLOYMENT TO DIGITALOCEAN

## 30-Minute Quick Start

### Phase 1: Prepare (5 mins)

```bash
# 1. Navigate to project
cd /home/kret/Downloads/gav

# 2. Make sure everything is committed to Git
git status

# 3. Ensure .gitignore exists and .env is NOT in git
git log --name-only --oneline | grep ".env"  # Should show nothing
```

### Phase 2: Push to GitHub (5 mins)

```bash
# If not done already:
git init
git add -A
git commit -m "IMOTH Tenders - Ready for deployment"

# Create repo on GitHub.com first, then:
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/imoth-tenders.git
git push -u origin main
```

### Phase 3: Deploy to DigitalOcean (20 mins)

#### Step 1: Create DigitalOcean Account
- Go to: https://www.digitalocean.com
- Sign up with email
- Add payment method

#### Step 2: Create App
1. Click **Apps** (left sidebar)
2. Click **Create App** button
3. Choose **GitHub** as source
4. Click **Authorize** and login to GitHub
5. Select repo: `imoth-tenders`
6. Branch: `main`
7. Click **Next**

#### Step 3: Configure Services
DO will auto-detect Node.js. Verify:

- **Service Name**: `imoth-tenders-backend`
- **Source**: GitHub (your repo)
- **HTTP Port**: `3000`
- **Build Command**: `npm install`
- **Run Command**: `npm start`

Click **Next →**

#### Step 4: Set Environment Variables
Click **Add Environment Variable** and add these:

```
SUPABASE_URL = https://YOUR_PROJECT.supabase.co
SUPABASE_SERVICE_ROLE_KEY = sb_secret_XXXXX
NODE_ENV = production
```

Get these values from:
- **Supabase Dashboard** → **Settings** → **API**

Click **Next →**

#### Step 5: Review & Deploy
- Review all settings
- Click **Create Resources**
- Wait 3-5 minutes for deployment

### Phase 4: Verify (5 mins)

1. After deployment, copy the app URL (e.g., `https://imoth-tenders-xxxxx.ondigitalocean.app`)

2. Test the app:
   ```
   https://imoth-tenders-xxxxx.ondigitalocean.app/imoth_tenders_patched.html
   ```

3. Try creating a new user to verify signup works

4. Check logs for errors:
   - DigitalOcean App Platform → **Runtime logs**

---

## Common Issues & Fixes

### "Failed to fetch from /api/signup"
**Fix**: Update `imoth_tenders_patched.html` line 429:
```javascript
const BACKEND_URL = 'https://imoth-tenders-xxxxx.ondigitalocean.app';
```
Then push changes to GitHub (auto-redeploy).

### "Cannot GET /"
**Fix**: This is expected. Access via `/imoth_tenders_patched.html`

### Service shows "Unhealthy"
1. Check **Runtime logs** for errors
2. Verify all env vars are set correctly
3. Verify Supabase credentials are correct
4. Restart app: Go to **Settings** → **Restart**

### CORS errors
**Fix**: Add your DigitalOcean domain to `server.js` line ~31:
```javascript
const allowedOrigins = [
  'https://imoth-tenders-xxxxx.ondigitalocean.app',
  'https://your-custom-domain.com'  // if using custom domain
];
```
Push to GitHub (auto-redeploy).

---

## Post-Deployment Checklist

- [ ] App is accessible and responds to requests
- [ ] User can view tenders table
- [ ] User can create new tender (test with POST request)
- [ ] User can sign up with email/password
- [ ] Audit log saves changes correctly
- [ ] Marketer assignments work
- [ ] No errors in Runtime logs
- [ ] App URL is bookmarked

---

## Next Steps (Optional)

### Add Custom Domain
1. DigitalOcean App → **Settings** → **Domains**
2. Add your domain
3. Update DNS in domain registrar (add CNAME record)
4. Wait 24 hours for propagation

### Enable Auto-Scaling
1. App **Settings** → **Auto-scaling**
2. Set Min instances: 1, Max: 3
3. CPU threshold: 70%

### Set Up Monitoring
1. Go to **Insight** tab
2. Monitor CPU, memory, requests
3. Set up alerts if needed

---

## Database Backup

Your data is safe with Supabase! 

To backup manually:
1. Supabase Dashboard → **Backups**
2. Click **Create backup now**

Backups are kept for 7 days by default.

---

## Rolling Back

If something goes wrong:

1. Go to **Deployments** tab in DigitalOcean
2. Find the previous working deployment
3. Click **Rollback**

Your app will revert to the previous version instantly.

---

## Support

- **DigitalOcean Support**: https://www.digitalocean.com/help
- **Check App Logs**: Your App → **Runtime logs**
- **Supabase Issues**: https://supabase.com/docs

---

**Your app is now live on DigitalOcean! 🎉**

Access it at: `https://imoth-tenders-xxxxx.ondigitalocean.app/imoth_tenders_patched.html`
