require "rails_helper"

RSpec.describe "User Login", type: :system do
  before do
    driven_by(:selenium_headless)
  end

  describe "client-side validation" do
    it "shows error for blank email without HTTP request" do
      visit new_user_session_path
      fill_in "Password", with: "password123"
      click_button "Log in"

      expect(page).to have_content("Email can't be blank")
    end

    it "shows error for blank password without HTTP request" do
      visit new_user_session_path
      fill_in "Email", with: "user@example.com"
      click_button "Log in"

      expect(page).to have_content("Password can't be blank")
    end
  end

  describe "successful login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "signs in user and redirects to home" do
      visit new_user_session_path
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"
      click_button "Log in"

      expect(page).to have_content("Stonksmate")
      expect(page).to have_current_path(root_path)
    end
  end
end
