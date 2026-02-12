# Video Demo Script - Backend Challenge NestJS

## 📹 Video Outline (Target: 5-10 menit)

### INTRO (30 detik)
- **Tampilan**: IDE dengan project structure
- **Narasi**: 
  - "Halo, ini adalah demo aplikasi Backend Challenge menggunakan NestJS dan TypeScript"
  - "Aplikasi ini adalah REST API untuk manajemen blog dengan fitur Users dan Posts"

---

## PART 1: PROJECT OVERVIEW (1 menit)

### 1.1 Struktur Project
- **Tampilan**: File explorer dengan folder structure
- **Narasi**: 
  - "Project ini menggunakan Modular Pattern"
  - "Terdiri dari 3 module utama: Auth, Users, dan Posts"
  
**Tunjukkan:**
```
src/
├── auth/      → JWT Authentication
├── users/     → Users CRUD
├── posts/     → Posts CRUD
└── app.module.ts
```

### 1.2 Tech Stack & Dependencies
- **Tampilan**: package.json
- **Narasi**:
  - "Menggunakan NestJS 11 dengan TypeScript"
  - "PostgreSQL sebagai database dengan TypeORM"
  - "JWT untuk authentication"
  - "bcrypt untuk password hashing"

---

## PART 2: CODE WALKTHROUGH (2-3 menit)

### 2.1 Entities & Relationships (30 detik)
- **Tampilan**: 
  - `users/entities/user.entity.ts`
  - `posts/entities/post.entity.ts`
  
- **Highlight**:
  - User entity dengan OneToMany ke Posts
  - Post entity dengan ManyToOne ke User
  - Relasi yang jelas: Satu user punya banyak posts

### 2.2 Authentication System (45 detik)
- **Tampilan**: 
  - `auth/auth.service.ts` - login method
  - `auth/strategies/jwt.strategy.ts`
  - `auth/guards/jwt-auth.guard.ts`

- **Narasi**:
  - "Authentication menggunakan JWT token"
  - "Password di-hash menggunakan bcrypt"
  - "Guard untuk protect routes yang memerlukan auth"

### 2.3 CRUD Services (45 detik)
- **Tampilan**:
  - `users/users.service.ts` - show create, findAll, update
  - `posts/posts.service.ts` - show create, update with authorization

- **Highlight**:
  - Repository pattern dengan TypeORM
  - Input validation menggunakan DTOs
  - Authorization check di posts service (user hanya bisa edit post sendiri)

### 2.4 Controllers & Routes (30 detik)
- **Tampilan**:
  - `users/users.controller.ts`
  - `posts/posts.controller.ts`

- **Highlight**:
  - Decorator @UseGuards(JwtAuthGuard)
  - Routes yang protected vs public
  - HTTP methods (GET, POST, PATCH, DELETE)

---

## PART 3: RUNNING APPLICATION (2-3 menit)

### 3.1 Start Server (30 detik)
- **Tampilan**: Terminal
- **Command**: `npm run start:dev`
- **Narasi**: "Aplikasi running di port 3000 dengan TypeORM auto-sync"

### 3.2 Demo API dengan Postman (2 menit)
**Import collection terlebih dahulu**

#### Request 1: Register User (20 detik)
- **Endpoint**: POST /users
- **Body**:
```json
{
  "email": "demo@example.com",
  "name": "Demo User",
  "password": "demo123"
}
```
- **Result**: Tunjukkan response dengan user ID (password tidak muncul)

#### Request 2: Login (20 detik)
- **Endpoint**: POST /auth/login
- **Body**:
```json
{
  "email": "demo@example.com",
  "password": "demo123"
}
```
- **Result**: Tunjukkan JWT token yang didapat
- **Note**: "Token ini otomatis tersimpan di Postman untuk request selanjutnya"

#### Request 3: Protected Route Tanpa Token (15 detik)
- **Endpoint**: GET /users (tanpa Authorization header)
- **Result**: 401 Unauthorized
- **Narasi**: "Tanpa token, tidak bisa akses protected route"

#### Request 4: Protected Route Dengan Token (15 detik)
- **Endpoint**: GET /users (dengan token)
- **Result**: List of users
- **Narasi**: "Dengan token, berhasil akses data"

#### Request 5: Create Post (20 detik)
- **Endpoint**: POST /posts
- **Body**:
```json
{
  "title": "My First Post",
  "content": "This is a test post",
  "published": true
}
```
- **Result**: Post created dengan author info
- **Highlight**: "Post otomatis ter-link ke user yang sedang login"

#### Request 6: Get All Posts (Public) (15 detik)
- **Endpoint**: GET /posts (tanpa token)
- **Result**: List of posts dengan author info
- **Narasi**: "Endpoint ini public, tidak perlu token"

#### Request 7: Update Post (15 detik)
- **Endpoint**: PATCH /posts/:id
- **Body**:
```json
{
  "title": "Updated Title"
}
```
- **Result**: Post updated
- **Narasi**: "User hanya bisa update post milik sendiri"

---

## PART 4: E2E TESTING (1 menit)

### 4.1 Run Tests
- **Tampilan**: Terminal
- **Command**: `npm run test:e2e`
- **Narasi**: 
  - "E2E tests mencakup semua flow authentication"
  - "Test registration, login, token validation"
  - "Test protected routes dengan valid/invalid token"

### 4.2 Test Results
- **Tampilan**: Test output dengan semua tests passing
- **Highlight**: 
  - ✓ User registration
  - ✓ Login validation
  - ✓ JWT token format
  - ✓ Protected routes
  - ✓ Create post with authentication
  
---

## PART 5: ARCHITECTURE EXPLANATION (1-2 menit)

### 5.1 Why Modular Pattern?
- **Tampilan**: Kembali ke project structure atau diagram
- **Narasi**:
  - "Menggunakan Modular Monolith Pattern karena:"
  - "1. Separation of Concerns - setiap module punya tanggung jawab jelas"
  - "2. Scalability - mudah tambah module baru"
  - "3. Maintainability - code terorganisir dengan baik"
  - "4. Testability - setiap module bisa di-test independen"

### 5.2 Why Repository Pattern?
- **Narasi**:
  - "Repository Pattern via TypeORM untuk:"
  - "1. Abstraction - pisahkan business logic dari data access"
  - "2. Type Safety - TypeScript + TypeORM"
  - "3. Flexibility - mudah ganti database"

### 5.3 Layered Architecture
- **Narasi**:
  - "Setiap module punya layer yang jelas:"
  - "- Entities: Data models"
  - "- DTOs: Validation"
  - "- Services: Business logic"
  - "- Controllers: HTTP handlers"

---

## CLOSING (30 detik)

### Summary Checklist
- **Tampilan**: README atau checklist
- **Narasi**:
  - "✅ 2 CRUD operations yang saling berkaitan (Users & Posts)"
  - "✅ SQL Database dengan PostgreSQL & TypeORM"
  - "✅ JWT Authentication"
  - "✅ E2E Testing"
  - "✅ Modular Pattern dengan penjelasan lengkap"
  - "Terima kasih!"

---

## 🎥 TIPS UNTUK RECORDING

### Before Recording:
1. ✅ Clean up terminal
2. ✅ Close unnecessary apps
3. ✅ Clear browser cache/cookies
4. ✅ Prepare Postman collection
5. ✅ Database sudah running
6. ✅ Test server bisa start

### During Recording:
- Gunakan zoom untuk highlight code penting
- Jangan terlalu cepat, beri waktu viewer untuk membaca
- Highlight cursor di bagian penting
- Speak clearly dan tidak terlalu cepat
- Pause sebentar setelah setiap step

### Tools:
- Screen recorder: OBS Studio / Loom / Windows Game Bar
- Zoom level: 150% untuk code
- Font size: Besar untuk readability
- Theme: Dark theme (easier on eyes)

### File Referensi:
- README.md - Dokumentasi lengkap
- QUICK_START.md - Setup guide
- postman_collection.json - API testing
- demo.ps1 - Automated demo script
- test/auth.e2e-spec.ts - E2E tests

---

## 📋 CHECKLIST SEBELUM SUBMIT

- [ ] Video mencakup semua poin requirement
- [ ] Code ter-commit dan ter-push ke GitHub
- [ ] README lengkap dengan penjelasan pattern
- [ ] Postman collection included
- [ ] E2E tests berjalan dan passing
- [ ] Database schema terdokumentasi
- [ ] .env.example tersedia (jangan .env yang ada password!)
- [ ] Video quality minimal 720p
- [ ] Audio clear dan terdengar
- [ ] Duration 5-10 menit
