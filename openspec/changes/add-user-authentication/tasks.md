## 1. Setup & Configuration

- [x] 1.1 Add Devise gem to Gemfile and run bundle install
- [x] 1.2 Set up Docker Compose with PostgreSQL for local development
- [x] 1.3 Update database.yml and Gemfile to use PostgreSQL
- [x] 1.4 Run Devise install generator (`rails generate devise:install`)
- [x] 1.5 Configure Devise initializer for Users::User model path
- [x] 1.6 Create users table migration with email unique constraint and NOT NULL constraints

## 2. Users Domain

- [x] 2.1 Create domain directory structure (`app/domains/users/`)
- [x] 2.2 Implement Users::User model with Devise modules (database_authenticatable, registerable, validatable)
- [x] 2.3 Implement Users::Exceptions module with NotFound error
- [x] 2.4 Implement Users::Repository with find method
- [x] 2.5 Implement Users::App facade with initialize(user:), current, and class method find(id)
- [x] 2.6 Add private_constant for Repository and Exceptions

## 3. Users Domain Tests

- [x] 3.1 Create Users::User factory with FactoryBot
- [x] 3.2 Write specs for Users::App facade (current, find)
- [x] 3.3 Write specs for private_constant enforcement (Repository, Exceptions not accessible)
- [x] 3.4 Write specs for Users::App.find raising exception for non-existent user

## 4. Devise Routes & Views

- [x] 4.1 Configure Devise routes for Users::User model with `singular: :user` for clean helper names
- [x] 4.2 Generate Devise views (`rails generate devise:views users`)
- [x] 4.3 Update registration view with form fields and Stimulus controller data attributes
- [x] 4.4 Update login view with form fields and Stimulus controller data attributes

## 5. Stimulus Controllers

- [x] 5.1 Create form_validation Stimulus controller with validation logic
- [x] 5.2 Add validation rules: blank checks, email format, password length (6+), confirmation match
- [x] 5.3 Add inline error display (show/hide error messages next to fields)
- [x] 5.4 Wire up registration form view with Stimulus controller
- [x] 5.5 Wire up login form view with Stimulus controller

## 6. System Specs (Form Validation)

- [x] 6.1 Write system specs for registration validation (blank email, invalid email, blank password, short password, confirmation mismatch)
- [x] 6.2 Write system specs for registration success flow
- [x] 6.3 Write system specs for login validation (blank email, blank password)
- [x] 6.4 Write system specs for login success flow

## 7. Backend Request Specs

- [x] 7.1 Write request specs for user registration (success, duplicate email, validation errors)
- [x] 7.2 Write request specs for user login (success, wrong password, non-existent user)
- [x] 7.3 Write request specs for user logout (success, when not signed in)
- [x] 7.4 Write request spec for signed-in user redirected from login page

## 8. Final Integration

- [x] 8.1 Run database migration
- [x] 8.2 Verify all RSpec tests pass (including system specs)
- [x] 8.3 Manual smoke test: register, login, logout flow
