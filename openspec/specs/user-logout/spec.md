## ADDED Requirements

### Requirement: User can sign out

The system SHALL allow authenticated users to end their session.

#### Scenario: Successful logout

User is signed in.

User clicks the sign out button/link.

System destroys the session and redirects to the login page. User is no longer authenticated.

#### Scenario: Logout when not signed in

User is not signed in.

User attempts to access the logout endpoint directly.

System redirects to the login page. No error is displayed.
