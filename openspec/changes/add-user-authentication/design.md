## Context

Stonksmate currently has no user model or authentication. All features will require user-scoped data access. This is the first domain being created and will establish patterns for future domains.

The project uses:
- Devise for authentication
- DDD architecture with App facades and repositories
- Hotwire (Turbo + Stimulus) for frontend interactivity
- PostgreSQL via Docker for local development

## Goals / Non-Goals

**Goals:**
- Establish the `users` domain following DDD patterns
- Integrate Devise without breaking domain encapsulation
- Provide a clean interface for other domains to access user context
- Create Stimulus controller for form validation

**Non-Goals:**
- API-only authentication (session-based for now)
- Custom authentication logic (leverage Devise)
- Admin users or roles (single user type)

## Decisions

### 1. Domain Structure

The `users` domain will follow the flat structure pattern:

```
app/domains/users/
├── app.rb           # Facade (public)
├── user.rb          # Users::User model (public - needed by Devise)
├── repository.rb    # Data access (private_constant)
└── exceptions.rb    # Domain-specific errors (private_constant)
```

Internal classes (`Repository`, `Exceptions`) use `private_constant` to prevent access from outside the domain. Only `App` and `User` are public — `App` is the entry point, `User` must be public for Devise.

**Rationale**: Keeps domain self-contained. The App facade wraps Devise functionality while maintaining the project's architecture patterns. `private_constant` enforces encapsulation at runtime.

**Alternative considered**: Putting User model logic directly in controllers — rejected because it bypasses domain encapsulation.

### 2. Devise Integration

Devise will handle:
- Password hashing (bcrypt)
- Session management
- Authentication helpers (`current_user`, `authenticate_user!`)

The User model lives in `app/domains/users/user.rb` as `Users::User`, keeping all domain code together.

**Rationale**: Consistent with DDD architecture — models belong with their domain. Devise can be configured to use a namespaced model.

**Alternative considered**: Standard `app/models/user.rb` location — rejected because it breaks domain encapsulation.

### 3. Controller Approach

Use Devise's default controllers with custom views. No need for API controllers yet.

Routes:
- `GET /users/sign_up` — registration form
- `POST /users` — create account
- `GET /users/sign_in` — login form
- `POST /users/sign_in` — authenticate
- `DELETE /users/sign_out` — logout

Configure Devise with `singular: :user` in routes to get clean helper names:
- `current_user` (not `current_users_user`)
- `user_signed_in?` (not `users_user_signed_in?`)
- `authenticate_user!` (not `authenticate_users_user!`)

These helpers are available in all controllers via ApplicationController.

**Rationale**: Standard Devise flow works for session-based auth. Custom controllers would add complexity without benefit.

### 4. User Context for Other Domains

Other domains receive user context through facade initialization:

```ruby
Portfolio::App.new(user: current_user).holdings
```

The `Users::App` facade provides:
- `find(id)` — lookup user by ID
- `current` — returns the initialized user

**Rationale**: Matches existing architecture pattern. Authorization is scoped at initialization, not per-method.

### 5. Stimulus Controllers

Create Stimulus controllers for client-side form validation:
- `form_validation_controller` — shared validation logic for auth forms

Validation behavior:
- Blank field checks
- Email format validation
- Password minimum length (6 chars)
- Password confirmation match (registration only)

Validation runs on submit — no HTTP request sent until client-side validation passes. Errors display inline next to fields.

**Rationale**: Stimulus is already installed with Rails 8, works with Propshaft, and is sufficient for form validation. No additional build tooling required.

### 6. Testing Strategy

**Backend (RSpec)**:
- Request specs for Devise endpoints (registration, login, logout)
- Domain specs for Users::App facade behavior
- System specs for full form validation flow (using Capybara)

**Rationale**: System specs with Capybara test the full stack including JavaScript. This validates Stimulus behavior without needing a separate JS testing framework for simple form validation.

## Local Development Setup

Docker Compose provides PostgreSQL for local development:

```yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_USER: stonksmate
      POSTGRES_PASSWORD: stonksmate
      POSTGRES_DB: stonksmate_development
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
```

**Rationale**: Docker ensures consistent PostgreSQL version across development environments. No local PostgreSQL installation required.

## Database Schema

```sql
CREATE TABLE users (
  id bigserial PRIMARY KEY,
  email varchar(255) NOT NULL,
  encrypted_password varchar(255) NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

CREATE UNIQUE INDEX index_users_on_email ON users (email);
```

**Constraints**:
- `email` unique at DB level (not just AR validation)
- `email` and `encrypted_password` NOT NULL

Devise modules enabled: `database_authenticatable`, `registerable`, `validatable`

Modules explicitly disabled: `recoverable`, `confirmable`, `rememberable`, `trackable`, `lockable`, `timeoutable`, `omniauthable`

## Risks / Trade-offs

**[Risk]** Devise's "magic" can conflict with DDD encapsulation
→ Mitigation: Keep Devise to auth only; business logic goes through `Users::App`

**[Risk]** Session-based auth limits future API development
→ Mitigation: Acceptable for MVP; can add token auth later without breaking existing flow

**[Risk]** Devise expects model in standard location
→ Mitigation: Configure Devise to use `Users::User` via `devise :database_authenticatable, class_name: 'Users::User'` in routes and initializer

## N+1 Considerations

None for this change. User lookups are by ID or current session — no collections to eager load.

## Affected Domains

- `users` (new) — primary domain for this change

No existing domains affected.
