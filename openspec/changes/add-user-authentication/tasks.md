## 1. Setup & Configuration

- [x] 1.1 Add Devise gem to Gemfile and run bundle install
- [ ] 1.2 Set up Docker Compose with PostgreSQL for local development
- [ ] 1.3 Update database.yml and Gemfile to use PostgreSQL
- [ ] 1.4 Run Devise install generator (`rails generate devise:install`)
- [ ] 1.5 Configure Devise initializer for Users::User model path
- [ ] 1.6 Create users table migration with email unique constraint and NOT NULL constraints

## 2. Users Domain

- [ ] 2.1 Create domain directory structure (`app/domains/users/`)
- [ ] 2.2 Implement Users::User model with Devise modules (database_authenticatable, registerable, validatable)
- [ ] 2.3 Implement Users::Exceptions module with NotFound error
- [ ] 2.4 Implement Users::Repository with find method
- [ ] 2.5 Implement Users::App facade with initialize(user:), current, and class method find(id)
- [ ] 2.6 Add private_constant for Repository and Exceptions

## 3. Users Domain Tests

- [ ] 3.1 Create Users::User factory with FactoryBot
- [ ] 3.2 Write specs for Users::App facade (current, find)
- [ ] 3.3 Write specs for private_constant enforcement (Repository, Exceptions not accessible)
- [ ] 3.4 Write specs for Users::App.find raising exception for non-existent user

## 4. Devise Routes & Views

- [ ] 4.1 Configure Devise routes for Users::User model with `singular: :user` for clean helper names
- [ ] 4.2 Generate Devise views (`rails generate devise:views users`)
- [ ] 4.3 Update registration view with form fields and Stimulus controller data attributes
- [ ] 4.4 Update login view with form fields and Stimulus controller data attributes

## 5. Stimulus Controllers

- [ ] 5.1 Create form_validation Stimulus controller with validation logic
- [ ] 5.2 Add validation rules: blank checks, email format, password length (6+), confirmation match
- [ ] 5.3 Add inline error display (show/hide error messages next to fields)
- [ ] 5.4 Wire up registration form view with Stimulus controller
- [ ] 5.5 Wire up login form view with Stimulus controller

## 6. System Specs (Form Validation)

- [ ] 6.1 Write system specs for registration validation (blank email, invalid email, blank password, short password, confirmation mismatch)
- [ ] 6.2 Write system specs for registration success flow
- [ ] 6.3 Write system specs for login validation (blank email, blank password)
- [ ] 6.4 Write system specs for login success flow

## 7. Backend Request Specs

- [ ] 7.1 Write request specs for user registration (success, duplicate email, validation errors)
- [ ] 7.2 Write request specs for user login (success, wrong password, non-existent user)
- [ ] 7.3 Write request specs for user logout (success, when not signed in)
- [ ] 7.4 Write request spec for signed-in user redirected from login page

## 8. Final Integration

- [ ] 8.1 Run database migration
- [ ] 8.2 Verify all RSpec tests pass (including system specs)
- [ ] 8.3 Manual smoke test: register, login, logout flow
