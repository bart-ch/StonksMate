## Why

Users need to securely access their personal portfolio data. Authentication is foundational — every feature depends on knowing who the user is to scope their data appropriately. Starting with auth establishes the users domain and sets the pattern for all future domains.

## What Changes

- Add user registration, login, and logout functionality
- Establish the users domain with App facade and repository pattern
- Integrate Devise for authentication handling
- Create the foundation for user-scoped data access across the app

## Capabilities

### New Capabilities

- `user-registration`: Users can create an account with email and password
- `user-login`: Users can sign in and maintain a session
- `user-logout`: Users can sign out and end their session
- `users-domain`: App facade providing user context for other domains

### Modified Capabilities

(none)

## Non-goals

- Password reset / forgot password flow (add later)
- Email confirmation (add later)
- OAuth / social login (add later)
- User profile editing (add later)
- Remember me / persistent sessions (use Devise defaults for now)

## Impact

- `docker-compose.yml` — PostgreSQL service for local development
- `app/domains/users/` — new domain directory with App facade, User model, and repository
- `app/controllers/` — Devise controllers for auth flows
- `app/javascript/controllers/` — Stimulus controller for form validation
- `db/migrate/` — users table migration
- `config/routes.rb` — Devise routes
- `config/database.yml` — PostgreSQL configuration
