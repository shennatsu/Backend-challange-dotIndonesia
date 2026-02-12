# Quick Start Guide

## Langkah-langkah Cepat

### 1. Persiapan Database
```bash
# Pastikan PostgreSQL sudah terinstall dan berjalan
# Buat database baru
createdb nestjs_challenge

# Atau via psql
psql -U postgres
CREATE DATABASE nestjs_challenge;
\q
```

### 2. Install Dependencies (jika belum)
```bash
npm install
```

### 3. Konfigurasi Environment
File `.env` sudah tersedia, sesuaikan kalau perlu:
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=       # Isi dengan password postgres Anda
DB_DATABASE=nestjs_challenge

JWT_SECRET=rahasia_sekali
JWT_EXPIRATION=24h

PORT=3000
```

### 4. Run Aplikasi
```bash
# Development mode (dengan auto-reload)
npm run start:dev

# Production mode
npm run build
npm run start:prod
```

### 5. Test E2E
```bash
npm run test:e2e
```

## Endpoints Quick Reference

### Base URL
```
http://localhost:3000
```

### 1. Register User
```bash
POST http://localhost:3000/users
Content-Type: application/json

{
  "email": "user@example.com",
  "name": "User Name",
  "password": "password123"
}
```

### 2. Login (Dapatkan JWT Token)
```bash
POST http://localhost:3000/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

# Response:
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid-here",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

### 3. Create Post (Perlu Token)
```bash
POST http://localhost:3000/posts
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "title": "My Blog Post",
  "content": "This is my blog post content",
  "published": true
}
```

### 4. Get All Posts (Tidak Perlu Token)
```bash
GET http://localhost:3000/posts
```

### 5. Get All Users (Perlu Token)
```bash
GET http://localhost:3000/users
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Testing Flow dengan cURL

### Step 1: Register User
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"name\":\"Test User\",\"password\":\"password123\"}"
```

### Step 2: Login
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
```
**Simpan `access_token` dari response!**

### Step 3: Create Post (ganti YOUR_TOKEN)
```bash
curl -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d "{\"title\":\"My First Post\",\"content\":\"Hello World\",\"published\":true}"
```

### Step 4: Get All Posts
```bash
curl http://localhost:3000/posts
```

## Postman Collection

Import file `postman_collection.json` ke Postman untuk dokumentasi API lengkap dengan auto-token management.

### Cara Import:
1. Buka Postman
2. Click "Import" button
3. Pilih file `postman_collection.json`
4. Collection akan otomatis muncul dengan semua endpoints

### Testing Flow di Postman:
1. **Create User** - Buat user baru
2. **Login** - Token akan otomatis tersimpan
3. **Create Post** - Token otomatis digunakan
4. **Get All Posts** - Lihat semua posts
5. Semua protected routes sudah auto-configured dengan token

## Troubleshooting

### Database Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:5432
```
**Solusi**: Pastikan PostgreSQL running
```bash
# Windows (jika pakai service)
net start postgresql-x64-14

# Atau cek status
pg_isready
```

### Port Already in Use
```
Error: listen EADDRINUSE: address already in use :::3000
```
**Solusi**: Ganti PORT di file `.env` atau stop aplikasi yang menggunakan port 3000

### JWT Secret Warning
Jika ada warning tentang JWT secret, pastikan file `.env` ada dan JWT_SECRET sudah diset.

## Architecture Highlights

### Modular Structure
- ✅ Auth Module (JWT authentication)
- ✅ Users Module (User CRUD)
- ✅ Posts Module (Posts CRUD)
- ✅ TypeORM (Database management)

### Security Features
- ✅ Password hashing dengan bcrypt
- ✅ JWT token authentication  - ✅ Protected routes dengan Guards
- ✅ Input validation dengan class-validator
- ✅ Authorization (user-specific operations)

### Testing
- ✅ E2E tests untuk authentication flow
- ✅ Token validation tests
- ✅ Protected routes tests
- ✅ Error scenarios tests

## Next Steps

Setelah aplikasi running:
1. ✅ Test semua endpoints dengan Postman
2. ✅ Run E2E tests dengan `npm run test:e2e`
3. ✅ Review code structure
4. ✅ Buat demo video
5. ✅ Deploy (optional)

---
