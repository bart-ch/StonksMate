import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "password", "passwordConfirmation", "emailError", "passwordError", "passwordConfirmationError", "searchField", "errorContainer"]

  connect() {
    this.clearErrors()
  }

  validate(event) {
    this.clearErrors()
    let isValid = true

    if (this.hasEmailTarget) {
      const emailValid = this.validateEmail()
      isValid = isValid && emailValid
    }

    if (this.hasPasswordTarget) {
      const passwordValid = this.validatePassword()
      isValid = isValid && passwordValid
    }

    if (this.hasPasswordConfirmationTarget) {
      const confirmationValid = this.validatePasswordConfirmation()
      isValid = isValid && confirmationValid
    }

    if (!isValid) {
      event.preventDefault()
    }
  }

  validateEmail() {
    const email = this.emailTarget.value.trim()

    if (email === "") {
      this.showError("emailError", "Email can't be blank")
      return false
    }

    const emailRegex = /^[^\s@]+@[^\s@]+$/
    if (!emailRegex.test(email)) {
      this.showError("emailError", "Email is invalid")
      return false
    }

    return true
  }

  validatePassword() {
    const password = this.passwordTarget.value

    if (password === "") {
      this.showError("passwordError", "Password can't be blank")
      return false
    }

    if (password.length < 6) {
      this.showError("passwordError", "Password is too short (minimum is 6 characters)")
      return false
    }

    return true
  }

  validatePasswordConfirmation() {
    if (!this.hasPasswordTarget) return true

    const password = this.passwordTarget.value
    const confirmation = this.passwordConfirmationTarget.value

    if (password !== confirmation) {
      this.showError("passwordConfirmationError", "Password confirmation doesn't match Password")
      return false
    }

    return true
  }

  showError(targetName, message) {
    const errorTarget = this[`${targetName}Target`]
    if (errorTarget) {
      errorTarget.textContent = message
      errorTarget.style.display = "block"
    }
  }

  clearErrors() {
    if (this.hasEmailErrorTarget) {
      this.emailErrorTarget.textContent = ""
      this.emailErrorTarget.style.display = "none"
    }
    if (this.hasPasswordErrorTarget) {
      this.passwordErrorTarget.textContent = ""
      this.passwordErrorTarget.style.display = "none"
    }
    if (this.hasPasswordConfirmationErrorTarget) {
      this.passwordConfirmationErrorTarget.textContent = ""
      this.passwordConfirmationErrorTarget.style.display = "none"
    }
    if (this.hasErrorContainerTarget) {
      this.errorContainerTarget.textContent = ""
    }
  }

  validateSearch(event) {
    this.clearErrors()

    if (this.hasSearchFieldTarget) {
      const query = this.searchFieldTarget.value.trim()

      if (query === "") {
        if (this.hasErrorContainerTarget) {
          this.errorContainerTarget.textContent = "Please enter a stock symbol or company name"
        }
        event.preventDefault()
      }
    }
  }
}
