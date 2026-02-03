## ADDED Requirements

### Requirement: Registration form validates input client-side

The system SHALL validate registration input on the client before submitting to the server.

#### Scenario: Blank email shows error without HTTP request

User is on registration page with empty email field.

User attempts to submit the form.

Form displays inline error "Email can't be blank" without sending HTTP request. Error clears when user fixes the field.

#### Scenario: Invalid email format shows error without HTTP request

User is on registration page with email "not-an-email".

User attempts to submit the form.

Form displays error "Email is invalid" without sending HTTP request.

#### Scenario: Blank password shows error without HTTP request

User is on registration page with empty password field.

User attempts to submit the form.

Form displays error "Password can't be blank" without sending HTTP request.

#### Scenario: Short password shows error without HTTP request

User is on registration page with password "12345" (less than 6 characters).

User attempts to submit the form.

Form displays error "Password is too short (minimum is 6 characters)" without sending HTTP request.

#### Scenario: Password confirmation mismatch shows error without HTTP request

User is on registration page with password "secret123" and confirmation "different456".

User attempts to submit the form.

Form displays error "Password confirmation doesn't match Password" without sending HTTP request.

### Requirement: User can register with email and password

The system SHALL allow visitors to create an account by providing an email address and password.

#### Scenario: Successful registration with valid credentials

User is not signed in.

User submits registration form with valid email and password (min 6 characters).

System creates the user account and signs them in automatically. User is redirected to the home page.

#### Scenario: Registration fails with duplicate email

User is not signed in. Another user exists with email "existing@example.com".

User submits registration form with email "existing@example.com".

System rejects registration and displays error "Email has already been taken". No account is created.

#### Scenario: Registration fails with invalid email format

User is not signed in.

User submits registration form with email "not-an-email".

System rejects registration and displays error "Email is invalid". No account is created.

#### Scenario: Registration fails with short password

User is not signed in.

User submits registration form with password shorter than 6 characters.

System rejects registration and displays error "Password is too short (minimum is 6 characters)". No account is created.

#### Scenario: Registration fails with mismatched password confirmation

User is not signed in.

User submits registration form with password "secret123" and confirmation "different456".

System rejects registration and displays error "Password confirmation doesn't match Password". No account is created.

#### Scenario: Registration fails with blank email

User is not signed in.

User submits registration form with blank email.

System rejects registration and displays error "Email can't be blank". No account is created.

#### Scenario: Registration fails with blank password

User is not signed in.

User submits registration form with blank password.

System rejects registration and displays error "Password can't be blank". No account is created.
