# Task Manager API

JSON API for managing tasks with authentication, priority ordering, comments, and multi-user collaboration. No frontend — API only.

## Requirements

- Ruby 3.3.10
- PostgreSQL
- Bundler

## Setup

```bash
bundle install
rails db:create db:migrate
```

## Running the app

```bash
rails server
```

## Linting (Rubocop)

The project uses [Rubocop](https://github.com/rubocop/rubocop) with the Rails Omakase config:

```bash
bundle exec rubocop
```

Auto-correct safe offenses:

```bash
bundle exec rubocop -a
```

## Authentication

All endpoints except register and login require the `Authorization` header:

```
Authorization: Bearer <jwt_token>
```

- **POST /register** — Body: `{ "email": "...", "password": "...", "password_confirmation": "..." }`. Returns `{ "token": "..." }`.
- **POST /login** — Body: `{ "email": "...", "password": "..." }`. Returns `{ "token": "..." }`.

## Tasks (existing, backward compatible)

- **GET /tasks** — List all tasks assigned to the current user (owned or assigned). Ordered by **priority** (asc), then `created_at`. Preserves priority ordering.
- **GET /tasks/:id** — Show task (must be owner or assignee).
- **POST /tasks** — Create task (body: `title`, optional `description`, `completed`, `priority`). Task belongs to current user.
- **PATCH/PUT /tasks/:id** — Update task (body: `title`, `description`, `completed`, `priority`). Only if user owns or is assigned.
- **DELETE /tasks/:id** — Delete task. Only task owner.

**Task fields:** `id`, `title`, `description`, `completed` (boolean), `priority` (integer, default 0), `user_id`, `created_at`, `updated_at`.

## Task assignments (multi-user access)

A task owner can assign other users to a task. Assignees can view the task, update priority/status, and add comments.

- **GET /tasks/:task_id/task_assignments** — List assignees (any user with access to the task).
- **POST /tasks/:task_id/task_assignments** — Add assignee. Body: `{ "user_id": <id> }`. **Only task owner.**
- **DELETE /tasks/:task_id/task_assignments/:id** — Remove assignee (`:id` is the `user_id` to remove). **Only task owner.**

## Comments

- **GET /tasks/:task_id/comments** — List comments for the task (any user with access). Ordered by `created_at`.
- **GET /tasks/:task_id/comments/:id** — Show one comment.
- **POST /tasks/:task_id/comments** — Create comment. Body: `{ "content": "..." }`. Any user with access to the task.
- **PATCH/PUT /tasks/:task_id/comments/:id** — Update comment. **Only the comment author.**
- **DELETE /tasks/:task_id/comments/:id** — Delete comment. **Only the comment author.**

**Comment fields:** `id`, `task_id`, `user_id`, `content`, `created_at`, `updated_at`.

Multiple users can comment on the same task. Users can edit/delete only their own comments and can view all comments on tasks they can access.

## Backward compatibility and breaking changes

- **Existing task endpoints** — Unchanged. `GET /tasks`, `GET /tasks/:id`, `POST /tasks`, `PATCH /tasks/:id`, `DELETE /tasks/:id` behave as before. Responses now include a `priority` field (integer); clients that ignore unknown fields remain compatible.
- **Task list order** — Tasks are now ordered by `priority` (asc), then `created_at`. If you relied on previous default order (e.g. `created_at` only), consider this a behavior change and use `priority` to control order.
- **Task ownership** — Tasks still have a single owner (`user_id`). New: owners can add *assignees* via task assignments; assignees can view and update tasks and add comments. Existing “only owner sees task” behavior remains for tasks with no assignees.

No existing endpoints were removed or renamed.
