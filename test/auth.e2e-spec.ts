/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */

import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';
import { DataSource } from 'typeorm';

describe('Authentication (e2e)', () => {
  let app: INestApplication;
  let authToken: string;
  let userId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();

    // Apply same configuration as main.ts
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );

    await app.init();

    // Clean up test data if exists from previous runs
    const dataSource = moduleFixture.get(DataSource);
    try {
      // First delete posts, then user (due to foreign key constraint)
      await dataSource.query(
        "DELETE FROM posts WHERE author_id IN (SELECT id FROM users WHERE email = 'test@example.com')",
      );
      await dataSource.query(
        "DELETE FROM users WHERE email = 'test@example.com'",
      );
    } catch (error) {
      // Ignore errors (data might not exist or database issue)
    }
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/auth/login (POST)', () => {
    it('should register a new user first', () => {
      return request(app.getHttpServer())
        .post('/users')
        .send({
          email: 'test@example.com',
          name: 'Test User',
          password: 'password123',
        })
        .expect(201)
        .then((response) => {
          expect(response.body).toHaveProperty('id');
          expect(response.body.email).toBe('test@example.com');
          expect(response.body.name).toBe('Test User');
          expect(response.body).not.toHaveProperty('password');
          userId = response.body.id;
        });
    });

    it('should fail login with invalid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'test@example.com',
          password: 'wrongpassword',
        })
        .expect(401)
        .then((response) => {
          expect(response.body.message).toBe('Invalid credentials');
        });
    });

    it('should successfully login with valid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'test@example.com',
          password: 'password123',
        })
        .expect(200)
        .then((response) => {
          expect(response.body).toHaveProperty('access_token');
          expect(response.body).toHaveProperty('user');
          expect(response.body.user.email).toBe('test@example.com');
          authToken = response.body.access_token;
        });
    });

    it('should validate JWT token format', () => {
      expect(authToken).toBeDefined();
      expect(authToken.split('.')).toHaveLength(3); // JWT has 3 parts
    });

    it('should fail to access protected route without token', () => {
      return request(app.getHttpServer()).get('/users').expect(401);
    });

    it('should access protected route with valid token', () => {
      return request(app.getHttpServer())
        .get('/users')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .then((response) => {
          expect(Array.isArray(response.body)).toBe(true);
          expect(response.body.length).toBeGreaterThan(0);
        });
    });

    it('should fail to access protected route with invalid token', () => {
      return request(app.getHttpServer())
        .get('/users')
        .set('Authorization', 'Bearer invalid_token')
        .expect(401);
    });

    it('should get user details with valid token', () => {
      return request(app.getHttpServer())
        .get(`/users/${userId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .then((response) => {
          expect(response.body.id).toBe(userId);
          expect(response.body.email).toBe('test@example.com');
          expect(response.body).not.toHaveProperty('password');
        });
    });

    it('should create a post with valid token', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          title: 'Test Post',
          content: 'This is a test post',
          published: true,
        })
        .expect(201)
        .then((response) => {
          expect(response.body).toHaveProperty('id');
          expect(response.body.title).toBe('Test Post');
          expect(response.body.author.id).toBe(userId);
        });
    });

    it('should fail to create a post without token', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .send({
          title: 'Test Post',
          content: 'This is a test post',
        })
        .expect(401);
    });

    it('should fail login with missing fields', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'test@example.com',
        })
        .expect(400);
    });

    it('should fail login with invalid email format', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'invalid-email',
          password: 'password123',
        })
        .expect(400);
    });
  });
});
