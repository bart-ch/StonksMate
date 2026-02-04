require "rails_helper"

RSpec.describe "User Registration", type: :system do
  before do
    driven_by(:selenium_headless)
  end

  describe "client-side validation" do
    it "shows error for blank email without HTTP request" do
      visit new_user_registration_path
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"

      expect(page).to have_content("Email can't be blank")
    end

    it "shows error for invalid email format without HTTP request" do
      visit new_user_registration_path
      fill_in "Email", with: "notanemail"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"

      page.execute_script("document.querySelector('form').setAttribute('novalidate', 'true')")
      click_button "Sign up"

      expect(page).to have_content("Email is invalid")
    end

    it "shows error for blank password without HTTP request" do
      visit new_user_registration_path
      fill_in "Email", with: "user@example.com"
      click_button "Sign up"

      expect(page).to have_content("Password can't be blank")
    end

    it "shows error for short password without HTTP request" do
      visit new_user_registration_path
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "12345"
      fill_in "Password confirmation", with: "12345"
      click_button "Sign up"

      expect(page).to have_content("Password is too short")
    end

    it "shows error for password confirmation mismatch without HTTP request" do
      visit new_user_registration_path
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "different456"
      click_button "Sign up"

      expect(page).to have_content("Password confirmation doesn't match")
    end
  end

  describe "successful registration" do
    it "creates account and signs in user" do
      visit new_user_registration_path
      fill_in "Email", with: "newuser@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"

      expect(page).to have_content("Stonksmate")
      expect(page).to have_current_path(root_path)
    end
  end
end
