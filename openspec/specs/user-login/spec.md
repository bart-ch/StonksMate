## ADDED Requirements

### Requirement: Login form validates input client-side

The system SHALL validate login input on the client before submitting to the server.

#### Scenario: Blank email shows error without HTTP request

User is on login page with empty email field.

User attempts to submit the form.

Form displays error "Email can't be blank" without sending HTTP request.

#### Scenario: Blank password shows error without HTTP request

User is on login page with empty password field.

User attempts to submit the form.

Form displays error "Password can't be blank" without sending HTTP request.

### Requirement: User can sign in with email and password

The system SHALL allow registered users to authenticate using their email and password.

#### Scenario: Successful login with valid credentials

User is not signed in. User account exists with email "user@example.com" and password "secret123".

User submits login form with email "user@example.com" and password "secret123".

System authenticates the user, creates a session, and redirects to the home page.

#### Scenario: Login fails with incorrect password

User is not signed in. User account exists with email "user@example.com".

User submits login form with email "user@example.com" and incorrect password.

System rejects login and displays error "Invalid Email or password". No session is created.

#### Scenario: Login fails with non-existent email

User is not signed in. No account exists with email "nobody@example.com".

User submits login form with email "nobody@example.com".

System rejects login and displays error "Invalid Email or password". No session is created.

#### Scenario: Login fails with blank email

User is not signed in.

User submits login form with blank email.

System rejects login and displays error "Invalid Email or password". No session is created.

#### Scenario: Login fails with blank password

User is not signed in. User account exists with email "user@example.com".

User submits login form with email "user@example.com" and blank password.

System rejects login and displays error "Invalid Email or password". No session is created.

#### Scenario: Already signed in user visits login page

User is signed in.

User navigates to the login page.

System redirects user to the home page.
