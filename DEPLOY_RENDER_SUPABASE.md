# Deploy HireOps API on Render with Supabase PostgreSQL

## 1. Create Supabase database

1. Create a Supabase project.
2. Open **Project Settings > Database > Connection string**.
3. Copy the pooled PostgreSQL connection string.
   - For Render, use Supabase's pooler connection if direct IPv6 is not available.
   - Keep the password private.

## 2. Deploy backend to Render

The repository includes `render.yaml` for a Render Blueprint.

Render service settings:

- Root directory: `backend`
- Build command: `npm install`
- Pre-deploy command: `npm run migrate:postgres`
- Start command: `npm start`

Required environment variables:

```text
MOCK_MODE=false
DB_CLIENT=postgres
DB_SSL=true
DATABASE_URL=<your Supabase Postgres connection string>
MAIL_FROM=noreply@hireops.app
```

Optional email variables:

```text
MAIL_HOST=
MAIL_PORT=
MAIL_USER=
MAIL_PASS=
```

After deploy, Render will give you a public API URL like:

```text
https://hireops-api.onrender.com
```

Test it:

```bash
curl https://hireops-api.onrender.com/
```

Expected response:

```json
{"success":true,"message":"HireOps API running","version":"1.0.0","mode":"database"}
```

## 3. Build public APK

Build the Flutter APK with the Render API URL:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://hireops-api.onrender.com
```

Do not use these in a public APK:

```text
localhost
10.0.2.2
192.168.x.x
```

## Demo login

The Postgres migration seeds:

```text
Email: admin@hireops.io
Password: password123
```
