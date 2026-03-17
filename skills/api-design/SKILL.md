---
name: api-design
description: Designs or reviews API endpoints, request/response contracts, and versioning. Ensures consistency, clarity, and backward compatibility. WHEN to use it - designing new API endpoints, versioning existing APIs, reviewing API changes, documenting API behavior, or planning deprecation.
license: MIT
metadata:
  category: coding
  handoff-from:
    - arch
  handoff-to:
    - dev
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @api-design — API Design Principles

**Philosophy:** APIs are contracts. Design for clarity, consistency, and evolution.

## When to invoke
- Designing new API endpoints
- Versioning existing APIs
- Reviewing API changes
- Documenting API behavior
- Planning API deprecation

## Responsibilities
- Design clear, consistent API interfaces
- Plan for backward compatibility
- Define error response formats
- Document API contracts
- Consider versioning strategy

---

## Core Principles

### 1. Consistency

**Use consistent patterns across all endpoints.**

```
Good (consistent):
GET    /api/articles/          # List
GET    /api/articles/{id}/     # Detail
POST   /api/articles/          # Create
PUT    /api/articles/{id}/     # Update
DELETE /api/articles/{id}/     # Delete

GET    /api/users/             # List
GET    /api/users/{id}/        # Detail
POST   /api/users/             # Create

Bad (inconsistent):
GET    /api/articles/          # List
GET    /api/article/{id}/      # Detail (singular!)
POST   /api/create-article/    # Create (different pattern)
PUT    /api/articles/update/{id}/  # Update (extra path segment)
```

### 2. Resource-Oriented

**URLs represent resources, not actions.**

```
❌ Action-oriented (RPC style)
POST /api/createUser
POST /api/deleteUser
POST /api/getUserById

✅ Resource-oriented (REST style)
POST   /api/users/        # Create user
DELETE /api/users/{id}/   # Delete user
GET    /api/users/{id}/   # Get user
```

### 3. Use HTTP Methods Correctly

```
GET    - Retrieve resource (safe, idempotent)
POST   - Create resource (not idempotent)
PUT    - Replace resource (idempotent)
PATCH  - Partial update (not necessarily idempotent)
DELETE - Remove resource (idempotent)
```

**Idempotent:** Multiple identical requests have same effect as single request

### 4. Meaningful Status Codes

```
2xx Success
200 OK              - Request succeeded
201 Created         - Resource created
204 No Content      - Success, no response body

4xx Client Errors
400 Bad Request     - Invalid input
401 Unauthorized    - Authentication required
403 Forbidden       - Authenticated but not allowed
404 Not Found       - Resource doesn't exist
409 Conflict        - Resource state conflict
422 Unprocessable   - Validation failed

5xx Server Errors
500 Internal Error  - Server error
502 Bad Gateway     - Upstream service error
503 Service Unavailable - Temporary outage
```

---

## URL Design

### Resource Naming

```
✅ Good
/api/articles/
/api/users/
/api/comments/
/api/articles/{id}/comments/

❌ Bad
/api/article/          # Use plural
/api/get-articles/     # Don't use verbs
/api/Articles/         # Use lowercase
/api/article_list/     # Use hyphens, not underscores
```

### Nested Resources

```
✅ Good (shallow nesting)
/api/articles/{id}/comments/
/api/users/{id}/articles/

❌ Bad (deep nesting)
/api/users/{id}/articles/{id}/comments/{id}/replies/
# Too deep, hard to understand

✅ Better (flat with filters)
/api/comments/?article_id={id}
/api/replies/?comment_id={id}
```

### Query Parameters

```
Filtering:
/api/articles/?category=tech&status=published

Sorting:
/api/articles/?sort=-published_date  # Descending
/api/articles/?sort=title             # Ascending

Pagination:
/api/articles/?page=2&page_size=20
/api/articles/?limit=20&offset=40

Field Selection:
/api/articles/?fields=id,title,author

Search:
/api/articles/?q=django
```

---

## Request/Response Format

### Request Body (POST/PUT/PATCH)

```json
POST /api/articles/
Content-Type: application/json

{
  "title": "My Article",
  "content": "Article content here",
  "category": "tech",
  "tags": ["django", "python"],
  "published": true
}
```

### Response Format

```json
// Success (200 OK)
{
  "id": 123,
  "title": "My Article",
  "content": "Article content here",
  "category": "tech",
  "tags": ["django", "python"],
  "published": true,
  "created_at": "2024-02-19T10:30:00Z",
  "updated_at": "2024-02-19T10:30:00Z",
  "author": {
    "id": 456,
    "name": "John Doe",
    "email": "john@example.com"
  }
}

// Error (400 Bad Request)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "title": ["This field is required"],
      "category": ["Invalid category"]
    }
  }
}

// Error (404 Not Found)
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Article not found"
  }
}
```

### Pagination Response

```json
GET /api/articles/?page=2&page_size=20

{
  "count": 150,
  "next": "/api/articles/?page=3&page_size=20",
  "previous": "/api/articles/?page=1&page_size=20",
  "results": [
    {
      "id": 21,
      "title": "Article 21",
      ...
    },
    ...
  ]
}
```

---

## Error Handling

### Consistent Error Format

```json
{
  "error": {
    "code": "ERROR_CODE",           // Machine-readable
    "message": "Human-readable message",
    "details": {},                   // Optional, field-specific errors
    "request_id": "abc123"           // For debugging
  }
}
```

### Error Codes

```python
# Define error codes as constants
class ErrorCode:
    VALIDATION_ERROR = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    UNAUTHORIZED = "UNAUTHORIZED"
    FORBIDDEN = "FORBIDDEN"
    RATE_LIMIT_EXCEEDED = "RATE_LIMIT_EXCEEDED"
    INTERNAL_ERROR = "INTERNAL_ERROR"

# Usage
return Response({
    "error": {
        "code": ErrorCode.VALIDATION_ERROR,
        "message": "Invalid input data",
        "details": serializer.errors
    }
}, status=400)
```

### Field-Level Validation Errors

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": ["Enter a valid email address"],
      "password": [
        "Password must be at least 8 characters",
        "Password must contain a number"
      ],
      "age": ["Ensure this value is greater than or equal to 18"]
    }
  }
}
```

---

## Versioning

### URL Versioning (Recommended)

```
/api/v1/articles/
/api/v2/articles/

Pros:
- Clear and explicit
- Easy to route
- Easy to deprecate old versions

Cons:
- URL changes between versions
```

### Header Versioning

```
GET /api/articles/
Accept: application/vnd.myapi.v2+json

Pros:
- URL stays the same
- More RESTful

Cons:
- Less visible
- Harder to test in browser
```

### When to Version

```
✅ Version when:
- Breaking changes (removing fields, changing types)
- Major behavior changes
- Incompatible authentication changes

❌ Don't version for:
- Adding new optional fields
- Adding new endpoints
- Bug fixes
- Performance improvements
```

### Backward Compatibility

```python
# ✅ Backward compatible (add optional field)
{
  "id": 123,
  "title": "Article",
  "new_field": "value"  # Optional, old clients ignore it
}

# ❌ Breaking change (remove field)
{
  "id": 123,
  # "title": "Article"  # Removed! Old clients break
}

# ❌ Breaking change (change type)
{
  "id": "123",  # Was number, now string! Old clients break
  "title": "Article"
}
```

---

## Authentication & Authorization

### Authentication Methods

```
1. Token-based (JWT)
   Authorization: Bearer <token>

2. API Key
   X-API-Key: <key>

3. OAuth 2.0
   Authorization: Bearer <access_token>

4. Session-based (cookies)
   Cookie: sessionid=<id>
```

### Example: JWT Authentication

```python
# Django REST Framework
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def protected_view(request):
    return Response({'message': f'Hello {request.user.username}'})

# Request
GET /api/protected/
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Response (200 OK)
{
  "message": "Hello john"
}

# Response (401 Unauthorized)
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication credentials were not provided"
  }
}
```

### Permission Levels

```python
# Public (no auth required)
GET /api/articles/

# Authenticated (any logged-in user)
POST /api/articles/

# Owner only (user can only modify their own resources)
PUT /api/articles/{id}/  # Only if request.user == article.author

# Admin only
DELETE /api/users/{id}/  # Only if request.user.is_admin
```

---

## Rate Limiting

### Response Headers

```
HTTP/1.1 200 OK
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1613592000

# When limit exceeded (429 Too Many Requests)
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1613592000
Retry-After: 3600

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Try again in 1 hour."
  }
}
```

---

## Documentation

### OpenAPI/Swagger

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0

paths:
  /api/articles/:
    get:
      summary: List articles
      parameters:
        - name: page
          in: query
          schema:
            type: integer
        - name: category
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: object
                properties:
                  count:
                    type: integer
                  results:
                    type: array
                    items:
                      $ref: '#/components/schemas/Article'

components:
  schemas:
    Article:
      type: object
      properties:
        id:
          type: integer
        title:
          type: string
        content:
          type: string
```

### Example Requests

```python
# In documentation, provide curl examples

# List articles
curl -X GET "https://api.example.com/api/articles/?page=1&category=tech"

# Create article
curl -X POST "https://api.example.com/api/articles/" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Article",
    "content": "Article content",
    "category": "tech"
  }'

# Update article
curl -X PUT "https://api.example.com/api/articles/123/" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Updated Title"
  }'
```

---

## Best Practices

### 1. Use Nouns, Not Verbs

```
❌ /api/getArticles
❌ /api/createUser
❌ /api/deleteComment

✅ GET /api/articles/
✅ POST /api/users/
✅ DELETE /api/comments/{id}/
```

### 2. Return Created Resource

```python
# POST /api/articles/
# Return 201 Created with full resource
{
  "id": 123,
  "title": "New Article",
  "created_at": "2024-02-19T10:30:00Z",
  ...
}
```

### 3. Support Partial Updates

```python
# PATCH /api/articles/123/
# Only update provided fields
{
  "title": "Updated Title"
  # Other fields unchanged
}
```

### 4. Use ISO 8601 for Dates

```json
{
  "created_at": "2024-02-19T10:30:00Z",
  "updated_at": "2024-02-19T15:45:30+05:30"
}
```

### 5. Provide Filtering, Sorting, Pagination

```
/api/articles/?category=tech&status=published&sort=-created_at&page=2
```

### 6. Use HTTPS Only

```
❌ http://api.example.com/
✅ https://api.example.com/
```

### 7. Version from Day One

```
✅ /api/v1/articles/
❌ /api/articles/  # Hard to version later
```

---

## Common Mistakes

### ❌ Exposing Internal IDs

```json
{
  "id": 123,
  "database_id": 456,  // Don't expose internal IDs
  "user_id": 789       // Use consistent ID field
}
```

### ✅ Use Consistent IDs

```json
{
  "id": "art_123",
  "author": {
    "id": "usr_456",
    "name": "John Doe"
  }
}
```

---

### ❌ Returning Different Structures

```json
// Success
{
  "data": { ... }
}

// Error
{
  "error": "Something went wrong"  // Inconsistent structure
}
```

### ✅ Consistent Response Structure

```json
// Success
{
  "id": 123,
  "title": "Article"
}

// Error
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Something went wrong"
  }
}
```

---

### ❌ No Pagination

```python
# Returns all 10,000 articles (slow, crashes clients)
GET /api/articles/
```

### ✅ Always Paginate

```python
GET /api/articles/?page=1&page_size=20
```

---

## Further Reading

- [REST API Design Best Practices](https://restfulapi.net/)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [OpenAPI Specification](https://swagger.io/specification/)
