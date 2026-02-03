require "rails_helper"

RSpec.describe "User Registration", type: :request do
  describe "POST /users" do
    context "with valid params" do
      it "creates a new user" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "newuser@example.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.to change(Users::User, :count).by(1)
      end

      it "signs in the user" do
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }

        expect(controller.current_user).to be_present
      end

      it "redirects to root" do
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with duplicate email" do
      before { create(:user, email: "existing@example.com") }

      it "does not create a user" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "existing@example.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.not_to change(Users::User, :count)
      end

      it "returns unprocessable entity" do
        post user_registration_path, params: {
          user: {
            email: "existing@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with invalid params" do
      it "does not create user with blank email" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        }.not_to change(Users::User, :count)
      end

      it "does not create user with short password" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "user@example.com",
              password: "12345",
              password_confirmation: "12345"
            }
          }
        }.not_to change(Users::User, :count)
      end
    end
  end
end
