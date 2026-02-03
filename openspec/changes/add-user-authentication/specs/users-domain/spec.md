## ADDED Requirements

### Requirement: Users domain provides App facade

The system SHALL provide a Users::App facade as the entry point for user-related operations.

#### Scenario: Initialize App with user context

A user record exists in the database.

Code initializes `Users::App.new(user: user)`.

The App instance is created and scoped to the provided user.

#### Scenario: Retrieve current user from App

App is initialized with a user.

Code calls `app.current`.

Returns the user instance that was provided during initialization.

### Requirement: Users domain encapsulates internal classes

The system SHALL use private_constant to prevent direct access to Repository and Exceptions from outside the domain.

#### Scenario: Repository is not accessible outside domain

External code attempts to access `Users::Repository`.

System raises NameError. The Repository class is private to the Users module.

#### Scenario: Exceptions is not accessible outside domain

External code attempts to access `Users::Exceptions`.

System raises NameError. The Exceptions module is private to the Users module.

#### Scenario: App is accessible outside domain

External code accesses `Users::App`.

System allows access. The App facade is the public interface.

#### Scenario: User model is accessible outside domain

External code accesses `Users::User`.

System allows access. The User model must be public for Devise integration.

### Requirement: Repository handles user persistence

The system SHALL provide a Repository class for database operations, accessible only through the App facade.

#### Scenario: Find user by ID through App

A user exists with ID 123.

Code calls `Users::App.find(123)`.

Returns the user with ID 123.

#### Scenario: Find non-existent user raises exception

No user exists with ID 999.

Code calls `Users::App.find(999)`.

Raises Users domain-specific not found exception.
