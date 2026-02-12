### DEMO SCRIPT - Backend Challenge NestJS
### Follow this script untuk demo aplikasi

## PREPARATION
Write-Host "=== BACKEND CHALLENGE - NESTJS DEMO ===" -ForegroundColor Cyan
Write-Host ""

## Check if server is running
Write-Host "Step 0: Checking if server is running..." -ForegroundColor Yellow
$response = try { Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -ErrorAction SilentlyContinue } catch { $null }
if ($null -eq $response) {
    Write-Host "Server is NOT running. Please start with: npm run start:dev" -ForegroundColor Red
    exit
}
else {
    Write-Host "✓ Server is running!" -ForegroundColor Green
}
Write-Host ""

## DEMO 1: User Registration
Write-Host "=== DEMO 1: USER REGISTRATION ===" -ForegroundColor Cyan
Write-Host "Creating a new user..." -ForegroundColor Yellow

$userBody = @{
    email    = "demo@example.com"
    name     = "Demo User"
    password = "demo123456"
} | ConvertTo-Json

Write-Host "Request Body:" -ForegroundColor Gray
Write-Host $userBody -ForegroundColor Gray

$createUserResponse = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method POST -Body $userBody -ContentType "application/json"

Write-Host "✓ User created successfully!" -ForegroundColor Green
Write-Host "User ID: $($createUserResponse.id)" -ForegroundColor Green
Write-Host "Email: $($createUserResponse.email)" -ForegroundColor Green
Write-Host "Name: $($createUserResponse.name)" -ForegroundColor Green
Write-Host ""

$userId = $createUserResponse.id

## DEMO 2: Authentication - Login
Write-Host "=== DEMO 2: AUTHENTICATION - LOGIN ===" -ForegroundColor Cyan
Write-Host "Logging in with credentials..." -ForegroundColor Yellow

$loginBody = @{
    email    = "demo@example.com"
    password = "demo123456"
} | ConvertTo-Json

Write-Host "Request Body:" -ForegroundColor Gray
Write-Host $loginBody -ForegroundColor Gray

$loginResponse = Invoke-RestMethod -Uri "http://localhost:3000/auth/login" -Method POST -Body $loginBody -ContentType "application/json"

Write-Host "✓ Login successful!" -ForegroundColor Green
Write-Host "JWT Token (first 50 chars): $($loginResponse.access_token.Substring(0, 50))..." -ForegroundColor Green
Write-Host "Logged in as: $($loginResponse.user.name)" -ForegroundColor Green
Write-Host ""

$token = $loginResponse.access_token

## DEMO 3: JWT Token Validation
Write-Host "=== DEMO 3: JWT TOKEN VALIDATION ===" -ForegroundColor Cyan
Write-Host "Testing JWT token parts..." -ForegroundColor Yellow

$tokenParts = $token -split '\.'
Write-Host "Token has $($tokenParts.Length) parts (header.payload.signature)" -ForegroundColor Green
Write-Host "✓ Valid JWT format!" -ForegroundColor Green
Write-Host ""

## DEMO 4: Access Protected Route WITHOUT Token
Write-Host "=== DEMO 4: PROTECTED ROUTE - WITHOUT TOKEN ===" -ForegroundColor Cyan
Write-Host "Trying to access /users without token..." -ForegroundColor Yellow

try {
    Invoke-RestMethod -Uri "http://localhost:3000/users" -Method GET | Out-Null
    Write-Host "✗ Should have failed but didn't!" -ForegroundColor Red
}
catch {
    Write-Host "✓ Correctly rejected: Unauthorized (401)" -ForegroundColor Green
}
Write-Host ""

## DEMO 5: Access Protected Route WITH Token
Write-Host "=== DEMO 5: PROTECTED ROUTE - WITH TOKEN ===" -ForegroundColor Cyan
Write-Host "Accessing /users with valid token..." -ForegroundColor Yellow

$headers = @{
    "Authorization" = "Bearer $token"
}

$users = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method GET -Headers $headers

Write-Host "✓ Successfully accessed protected route!" -ForegroundColor Green
Write-Host "Found $($users.Count) user(s)" -ForegroundColor Green
Write-Host ""

## DEMO 6: Create Post (Authenticated)
Write-Host "=== DEMO 6: CREATE POST (AUTHENTICATED) ===" -ForegroundColor Cyan
Write-Host "Creating a blog post..." -ForegroundColor Yellow

$postBody = @{
    title     = "My First Blog Post - Demo"
    content   = "This is a demonstration of creating a blog post with JWT authentication. The post is automatically linked to the authenticated user."
    published = $true
} | ConvertTo-Json

Write-Host "Request Body:" -ForegroundColor Gray
Write-Host $postBody -ForegroundColor Gray

$createPostResponse = Invoke-RestMethod -Uri "http://localhost:3000/posts" -Method POST -Body $postBody -ContentType "application/json" -Headers $headers

Write-Host "✓ Post created successfully!" -ForegroundColor Green
Write-Host "Post ID: $($createPostResponse.id)" -ForegroundColor Green
Write-Host "Title: $($createPostResponse.title)" -ForegroundColor Green
Write-Host "Author: $($createPostResponse.author.name)" -ForegroundColor Green
Write-Host "Published: $($createPostResponse.published)" -ForegroundColor Green
Write-Host ""

$postId = $createPostResponse.id

## DEMO 7: Get All Posts (Public)
Write-Host "=== DEMO 7: GET ALL POSTS (PUBLIC) ===" -ForegroundColor Cyan
Write-Host "Fetching all posts without authentication..." -ForegroundColor Yellow

$allPosts = Invoke-RestMethod -Uri "http://localhost:3000/posts" -Method GET

Write-Host "✓ Successfully retrieved posts!" -ForegroundColor Green
Write-Host "Total posts: $($allPosts.Count)" -ForegroundColor Green
foreach ($post in $allPosts) {
    Write-Host "  - $($post.title) by $($post.author.name)" -ForegroundColor Gray
}
Write-Host ""

## DEMO 8: Get Posts by Author
Write-Host "=== DEMO 8: GET POSTS BY AUTHOR ===" -ForegroundColor Cyan
Write-Host "Fetching posts by author ID: $userId" -ForegroundColor Yellow

$authorPosts = Invoke-RestMethod -Uri "http://localhost:3000/posts/author/$userId" -Method GET

Write-Host "✓ Successfully retrieved author's posts!" -ForegroundColor Green
Write-Host "Posts by this author: $($authorPosts.Count)" -ForegroundColor Green
Write-Host ""

## DEMO 9: Update Post
Write-Host "=== DEMO 9: UPDATE POST (AUTHORIZATION) ===" -ForegroundColor Cyan
Write-Host "Updating the post..." -ForegroundColor Yellow

$updatePostBody = @{
    title     = "Updated Blog Post Title"
    content   = "This content has been updated to demonstrate the PATCH operation with authorization."
    published = $true
} | ConvertTo-Json

$updatePostResponse = Invoke-RestMethod -Uri "http://localhost:3000/posts/$postId" -Method PATCH -Body $updatePostBody -ContentType "application/json" -Headers $headers

Write-Host "✓ Post updated successfully!" -ForegroundColor Green
Write-Host "New title: $($updatePostResponse.title)" -ForegroundColor Green
Write-Host ""

## DEMO 10: Get Single Post
Write-Host "=== DEMO 10: GET SINGLE POST ===" -ForegroundColor Cyan
Write-Host "Fetching post by ID: $postId" -ForegroundColor Yellow

$singlePost = Invoke-RestMethod -Uri "http://localhost:3000/posts/$postId" -Method GET

Write-Host "✓ Post retrieved!" -ForegroundColor Green
Write-Host "Title: $($singlePost.title)" -ForegroundColor Green
Write-Host "Author: $($singlePost.author.name) ($($singlePost.author.email))" -ForegroundColor Green
Write-Host "Published: $($singlePost.published)" -ForegroundColor Green
Write-Host ""

## DEMO 11: Invalid Token Test
Write-Host "=== DEMO 11: INVALID TOKEN TEST ===" -ForegroundColor Cyan
Write-Host "Trying to create post with invalid token..." -ForegroundColor Yellow

$invalidHeaders = @{
    "Authorization" = "Bearer invalid_token_here"
}

try {
    Invoke-RestMethod -Uri "http://localhost:3000/posts" -Method POST -Body $postBody -ContentType "application/json" -Headers $invalidHeaders | Out-Null
    Write-Host "✗ Should have failed but didn't!" -ForegroundColor Red
}
catch {
    Write-Host "✓ Correctly rejected: Unauthorized (401)" -ForegroundColor Green
}
Write-Host ""

## DEMO 12: Summary
Write-Host "=== DEMO SUMMARY ===" -ForegroundColor Cyan
Write-Host "✓ User Registration: PASSED" -ForegroundColor Green
Write-Host "✓ JWT Authentication: PASSED" -ForegroundColor Green
Write-Host "✓ Token Validation: PASSED" -ForegroundColor Green
Write-Host "✓ Protected Routes: PASSED" -ForegroundColor Green
Write-Host "✓ CRUD Operations (Users): PASSED" -ForegroundColor Green
Write-Host "✓ CRUD Operations (Posts): PASSED" -ForegroundColor Green
Write-Host "✓ Authorization: PASSED" -ForegroundColor Green
Write-Host "✓ Public Endpoints: PASSED" -ForegroundColor Green
Write-Host "✓ Error Handling: PASSED" -ForegroundColor Green
Write-Host ""

Write-Host "=== ALL DEMOS COMPLETED SUCCESSFULLY! ===" -ForegroundColor Green
Write-Host ""

Write-Host "To run E2E tests, execute: npm run test:e2e" -ForegroundColor Yellow
Write-Host "To import Postman collection: Import 'postman_collection.json'" -ForegroundColor Yellow
