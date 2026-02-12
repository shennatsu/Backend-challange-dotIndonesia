# Backend Challenge - NestJS TypeScript API

## Project Overview

REST API aplikasi manajemen blog yang dibangun menggunakan NestJS dan TypeScript. Aplikasi ini memiliki 2 entitas yang saling berelasi: **Users** dan **Posts**, dilengkapi dengan autentikasi JWT dan E2E testing.

## Features

### Requirement Checklist
- [x] **2 CRUD Operations yang Saling Berkaitan**
  - Users CRUD (Create, Read, Update, Delete)
  - Posts CRUD (Create, Read, Update, Delete)
  - Relasi: Posts dimiliki oleh Users (One-to-Many)

- [x] **SQL Database**
  - PostgreSQL
  - TypeORM sebagai ORM
  - Auto-generated database schema

- [x] **JWT Authentication**
  - Login endpoint (`POST /auth/login`)
  - Token generation
  - Protected routes dengan JWT Guard
  - Token validation

- [x] **E2E Testing untuk Authentication**
  - Complete authentication flow testing
  - Token validation tests
  - Protected route access tests
  - Error scenario tests

## Architecture Pattern

### **Modular Monolith Pattern dengan Repository Pattern**

#### 1. **Modular Structure**
Aplikasi dibagi menjadi beberapa module yang independen namun dapat berkomunikasi:
```
src/
├── auth/           # Authentication module (JWT)
├── users/          # Users module (CRUD)
├── posts/          # Posts module (CRUD)
└── app.module.ts   # Root module
```

**Keuntungan:**
- **Separation of Concerns**: Setiap module memiliki tanggung jawab yang jelas
- **Scalability**: Mudah menambahkan module baru tanpa mempengaruhi module lain
- **Maintainability**: Code lebih mudah di-maintain karena terorganisir dengan baik
- **Testability**: Setiap module dapat di-test secara independen
- **Team Collaboration**: Tim dapat bekerja pada module berbeda tanpa conflict

#### 2. **Repository Pattern (via TypeORM)**
Menggunakan TypeORM Repository untuk data access layer:
```typescript
@InjectRepository(User)
private usersRepository: Repository<User>
```

**Keuntungan:**
- **Abstraction**: Memisahkan business logic dari data access logic
- **Flexibility**: Mudah mengganti database tanpa mengubah business logic
- **Type Safety**: TypeScript + TypeORM memberikan type safety
- **Query Builder**: Built-in query builder yang powerful
- **Migrations**: Database schema versioning

#### 3. **Layered Architecture**
Setiap module memiliki layer yang jelas:
```
Module/
├── entities/        # Data models (ORM entities)
├── dto/            # Data Transfer Objects (validation)
├── controllers/    # HTTP request handlers
├── services/       # Business logic
└── module.ts       # Module configuration
```

**Keuntungan:**
- **Clear Responsibility**: Setiap layer punya tugas spesifik
- **Dependency Injection**: NestJS DI container untuk loose coupling
- **Validation**: DTO dengan class-validator untuk input validation
- **Reusability**: Services dapat dipanggil dari berbagai controller

#### 4. **Guard Pattern untuk Authorization**
JWT Guard untuk protecting routes:
```typescript
@UseGuards(JwtAuthGuard)
@Get()
findAll() { ... }
```

**Keuntungan:**
- **Centralized Auth Logic**: Authorization logic di satu tempat
- **Declarative**: Easy to read dan understand
- **Reusable**: Guard dapat digunakan di berbagai routes
- **Secure by Default**: Explicit protection untuk sensitive routes

## Tech Stack

- **Framework**: NestJS 11.x
- **Language**: TypeScript 5.x
- **Database**: PostgreSQL
- **ORM**: TypeORM 0.3.x
- **Authentication**: JWT (jsonwebtoken via @nestjs/jwt)
- **Validation**: class-validator & class-transformer
- **Password**: bcrypt for hashing
- **Testing**: Jest + Supertest (E2E)

## Installation

### Prerequisites
- Node.js (v18 atau lebih tinggi)
- PostgreSQL (v12 atau lebih tinggi)
- npm atau yarn

### Steps

1. Clone repository
```bash
git clone <repository-url>
cd backend-challange
```

2. Install dependencies
```bash
npm install
```

3. Setup database
```bash
# Buat database PostgreSQL
createdb nestjs_challenge

# Atau via psql
psql -U postgres
CREATE DATABASE nestjs_challenge;
```

4. Configure environment
```bash
# File .env sudah ada, sesuaikan dengan konfigurasi lokal Anda:
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_DATABASE=nestjs_challenge

JWT_SECRET=rahasia_sekali
JWT_EXPIRATION=24h

PORT=3000
```

5. Run application
```bash
# Development mode
npm run start:dev

# Production mode
npm run build
npm run start:prod
```

##  Testing

### E2E Testing
```bash
# Run E2E tests
npm run test:e2e

# Run E2E tests with coverage
npm run test:cov
```

E2E tests mencakup:
- User registration
- Login dengan credentials yang valid/invalid
- JWT token validation
- Access ke protected routes dengan/tanpa token
- Token format validation
- Create posts dengan authentication

## API Documentation

### Base URL
```
http://localhost:3000
```

### Endpoints

#### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/login` | Login user | No |

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

#### Users

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/users` | Create new user | No |
| GET | `/users` | Get all users | Yes |
| GET | `/users/:id` | Get user by ID | Yes |
| PATCH | `/users/:id` | Update user | Yes |
| DELETE | `/users/:id` | Delete user | Yes |

**Create User:**
```json
{
  "email": "user@example.com",
  "name": "User Name",
  "password": "password123"
}
```

**Update User:**
```json
{
  "email": "newemail@example.com",
  "name": "New Name",
  "password": "newpassword"
}
```

#### Posts

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/posts` | Create new post | Yes |
| GET | `/posts` | Get all posts | No |
| GET | `/posts/:id` | Get post by ID | No |
| GET | `/posts/author/:authorId` | Get posts by author | No |
| PATCH | `/posts/:id` | Update post (own only) | Yes |
| DELETE | `/posts/:id` | Delete post (own only) | Yes |

**Create Post:**
```json
{
  "title": "Post Title",
  "content": "Post content here...",
  "published": true
}
```

**Update Post:**
```json
{
  "title": "Updated Title",
  "content": "Updated content",
  "published": false
}
```

### Authentication

Untuk mengakses protected endpoints, sertakan JWT token di header:
```
Authorization: Bearer <your_jwt_token>
```

## Project Structure

```
backend-challange/
├── src/
│   ├── auth/
│   │   ├── dto/
│   │   │   └── login.dto.ts
│   │   ├── guards/
│   │   │   └── jwt-auth.guard.ts
│   │   ├── strategies/
│   │   │   └── jwt.strategy.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   └── auth.module.ts
│   │
│   ├── users/
│   │   ├── dto/
│   │   │   ├── create-user.dto.ts
│   │   │   └── update-user.dto.ts
│   │   ├── entities/
│   │   │   └── user.entity.ts
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   └── users.module.ts
│   │
│   ├── posts/
│   │   ├── dto/
│   │   │   ├── create-post.dto.ts
│   │   │   └── update-post.dto.ts
│   │   ├── entities/
│   │   │   └── post.entity.ts
│   │   ├── posts.controller.ts
│   │   ├── posts.service.ts
│   │   └── posts.module.ts
│   │
│   ├── app.module.ts
│   └── main.ts
│
├── test/
│   ├── auth.e2e-spec.ts
│   └── jest-e2e.json
│
├── .env
├── package.json
├── tsconfig.json
└── README.md
```

## Security Features

1. **Password Hashing**: Menggunakan bcrypt dengan salt rounds 10
2. **JWT Token**: Secure token-based authentication
3. **Input Validation**: class-validator untuk validate semua input
4. **Authorization**: Users hanya bisa update/delete post mereka sendiri
5. **Environment Variables**: Sensitive data di environment variables

## Best Practices Implemented

1. **DTOs (Data Transfer Objects)**: Untuk validation dan type safety
2. **Entity Serialization**: Password tidak pernah di-return ke client
3. **Global Pipes**: Validation dan transformation di global level
4. **Error Handling**: Proper HTTP status codes dan error messages
5. **Dependency Injection**: Loose coupling antar components
6. **TypeScript**: Full type safety throughout the application
7. **CORS**: Enabled untuk cross-origin requests
8. **Environment Configuration**: Centralized configuration management

## Database Schema

### Users Table
```sql
users (
  id UUID PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
)
```

### Posts Table
```sql
posts (
  id UUID PRIMARY KEY,
  title VARCHAR NOT NULL,
  content TEXT NOT NULL,
  published BOOLEAN DEFAULT FALSE,
  author_id UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
)
```

### Relationships
- One User can have Many Posts (One-to-Many)
- One Post belongs to One User (Many-to-One)

## License

This project is [MIT licensed](LICENSE).

---

**Note**: Pastikan PostgreSQL sudah running sebelum menjalankan aplikasi. Database tables akan otomatis dibuat oleh TypeORM (synchronize: true) saat pertama kali aplikasi dijalankan.
