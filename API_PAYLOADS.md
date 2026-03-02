# API Payload Examples

## Authentication

### Register
```http
POST /register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Login
```http
POST /login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## Tasks

### Create Task (with priority)
```http
POST /tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Complete project documentation",
  "description": "Write comprehensive API documentation",
  "completed": false,
  "priority": 1
}
```

**Response:**
```json
{
  "id": 1,
  "title": "Complete project documentation",
  "description": "Write comprehensive API documentation",
  "completed": false,
  "priority": 1,
  "user_id": 1,
  "created_at": "2026-02-19T10:00:00.000Z",
  "updated_at": "2026-02-19T10:00:00.000Z"
}
```

### Update Task (priority and status)
```http
PATCH /tasks/1
Authorization: Bearer <token>
Content-Type: application/json

{
  "priority": 5,
  "completed": true
}
```

**Or update multiple fields:**
```json
{
  "title": "Updated task title",
  "description": "Updated description",
  "priority": 3,
  "completed": false
}
```

**Response:**
```json
{
  "id": 1,
  "title": "Updated task title",
  "description": "Updated description",
  "completed": false,
  "priority": 3,
  "user_id": 1,
  "created_at": "2026-02-19T10:00:00.000Z",
  "updated_at": "2026-02-19T10:05:00.000Z"
}
```

### List Tasks (ordered by priority)
```http
GET /tasks
Authorization: Bearer <token>
```

**Response:** Returns all tasks you own OR are assigned to, ordered by priority.
```json
[
  {
    "id": 1,
    "title": "High priority task",
    "description": "Important task",
    "completed": false,
    "priority": 1,
    "user_id": 1,
    "is_owner": true,
    "created_at": "2026-02-19T10:00:00.000Z",
    "updated_at": "2026-02-19T10:00:00.000Z"
  },
  {
    "id": 2,
    "title": "Assigned task",
    "description": "Task assigned to me",
    "completed": false,
    "priority": 2,
    "user_id": 3,
    "is_owner": false,
    "created_at": "2026-02-19T09:00:00.000Z",
    "updated_at": "2026-02-19T09:00:00.000Z"
  }
]
```

**Filter Options:**

**Get only tasks you own:**
```http
GET /tasks?filter=owned
Authorization: Bearer <token>
```

**Get only tasks assigned to you (not owned):**
```http
GET /tasks?filter=assigned
Authorization: Bearer <token>
```

**Get all accessible tasks (default):**
```http
GET /tasks
Authorization: Bearer <token>
```

### Get Task
```http
GET /tasks/1
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": 1,
  "title": "Complete project documentation",
  "description": "Write comprehensive API documentation",
  "completed": false,
  "priority": 1,
  "user_id": 1,
  "is_owner": true,
  "created_at": "2026-02-19T10:00:00.000Z",
  "updated_at": "2026-02-19T10:00:00.000Z"
}
```

**Note:** `is_owner` indicates if you own this task (`true`) or are assigned to it (`false`).

### Delete Task
```http
DELETE /tasks/1
Authorization: Bearer <token>
```

**Response:** `204 No Content`

---

## Task Assignments

### List Assignees
```http
GET /tasks/1/task_assignments
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": 2,
    "email": "assignee@example.com",
    "created_at": "2026-02-19T08:00:00.000Z"
  },
  {
    "id": 3,
    "email": "another@example.com",
    "created_at": "2026-02-19T09:00:00.000Z"
  }
]
```

### Assign User to Task
```http
POST /tasks/1/task_assignments
Authorization: Bearer <token>
Content-Type: application/json

{
  "user_id": 2
}
```

**Response:**
```json
{
  "message": "User assigned to task"
}
```

**Status:** `201 Created`

### Remove Assignee from Task
```http
DELETE /tasks/1/task_assignments/2
Authorization: Bearer <token>
```

**Note:** The `2` in the URL is the `user_id` of the assignee to remove.

**Response:** `204 No Content`

---

## Comments

### List Comments for a Task
```http
GET /tasks/1/comments
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": 1,
    "task_id": 1,
    "user_id": 1,
    "content": "This task looks good!",
    "created_at": "2026-02-19T10:00:00.000Z",
    "updated_at": "2026-02-19T10:00:00.000Z",
    "user": {
      "id": 1,
      "email": "user@example.com"
    }
  },
  {
    "id": 2,
    "task_id": 1,
    "user_id": 2,
    "content": "I'll help with this.",
    "created_at": "2026-02-19T10:05:00.000Z",
    "updated_at": "2026-02-19T10:05:00.000Z",
    "user": {
      "id": 2,
      "email": "assignee@example.com"
    }
  }
]
```

### Get Single Comment
```http
GET /tasks/1/comments/1
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": 1,
  "task_id": 1,
  "user_id": 1,
  "content": "This task looks good!",
  "created_at": "2026-02-19T10:00:00.000Z",
  "updated_at": "2026-02-19T10:00:00.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

### Create Comment
```http
POST /tasks/1/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "I've started working on this task."
}
```

**Response:**
```json
{
  "id": 3,
  "task_id": 1,
  "user_id": 1,
  "content": "I've started working on this task.",
  "created_at": "2026-02-19T10:10:00.000Z",
  "updated_at": "2026-02-19T10:10:00.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Status:** `201 Created`

### Update Comment (only own comments)
```http
PATCH /tasks/1/comments/3
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Updated: I've completed the first part."
}
```

**Response:**
```json
{
  "id": 3,
  "task_id": 1,
  "user_id": 1,
  "content": "Updated: I've completed the first part.",
  "created_at": "2026-02-19T10:10:00.000Z",
  "updated_at": "2026-02-19T10:15:00.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Error Response (if trying to edit someone else's comment):**
```json
{
  "error": "Forbidden - you can only edit or delete your own comments"
}
```

**Status:** `403 Forbidden`

### Delete Comment (only own comments)
```http
DELETE /tasks/1/comments/3
Authorization: Bearer <token>
```

**Response:** `204 No Content`

**Error Response (if trying to delete someone else's comment):**
```json
{
  "error": "Forbidden - you can only edit or delete your own comments"
}
```

**Status:** `403 Forbidden`

---

## Complete Workflow Example

### 1. User A creates a task
```http
POST /tasks
Authorization: Bearer <token_a>
Content-Type: application/json

{
  "title": "Design new feature",
  "description": "Create UI mockups",
  "priority": 2
}
```

### 2. User A assigns User B to the task
```http
POST /tasks/1/task_assignments
Authorization: Bearer <token_a>
Content-Type: application/json

{
  "user_id": 2
}
```

### 3. User B views the task (now accessible)
```http
GET /tasks/1
Authorization: Bearer <token_b>
```

### 4. User A adds a comment
```http
POST /tasks/1/comments
Authorization: Bearer <token_a>
Content-Type: application/json

{
  "content": "Please review the requirements first."
}
```

### 5. User B adds a comment
```http
POST /tasks/1/comments
Authorization: Bearer <token_b>
Content-Type: application/json

{
  "content": "Will do! Starting now."
}
```

### 6. Both users see all comments
```http
GET /tasks/1/comments
Authorization: Bearer <token_a>
```

**Response shows both comments with user info.**

### 7. User B updates their own comment
```http
PATCH /tasks/1/comments/2
Authorization: Bearer <token_b>
Content-Type: application/json

{
  "content": "Will do! Starting now. Update: Done!"
}
```

### 8. User B tries to edit User A's comment (fails)
```http
PATCH /tasks/1/comments/1
Authorization: Bearer <token_b>
Content-Type: application/json

{
  "content": "This will fail"
}
```

**Response:** `403 Forbidden` with error message.

---

## Error Responses

### Unauthorized (missing/invalid token)
```json
{
  "error": "Unauthorized"
}
```
**Status:** `401 Unauthorized`

### Not Found
```json
{
  "error": "Task not found"
}
```
**Status:** `404 Not Found`

### Validation Errors
```json
{
  "title": ["can't be blank"],
  "priority": ["must be a number"]
}
```
**Status:** `422 Unprocessable Entity`

### Forbidden
```json
{
  "error": "Only the task owner can delete the task"
}
```
**Status:** `403 Forbidden`
