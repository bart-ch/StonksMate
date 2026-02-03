require "rails_helper"

RSpec.describe "User Session", type: :request do
  describe "POST /users/sign_in" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    context "with valid credentials" do
      it "signs in the user" do
        post user_session_path, params: {
          user: {
            email: "test@example.com",
            password: "password123"
          }
        }

        expect(controller.current_user).to eq(user)
      end

      it "redirects to root" do
        post user_session_path, params: {
          user: {
            email: "test@example.com",
            password: "password123"
          }
        }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with wrong password" do
      it "does not sign in user" do
        post user_session_path, params: {
          user: {
            email: "test@example.com",
            password: "wrongpassword"
          }
        }

        expect(controller.current_user).to be_nil
      end

      it "returns unprocessable entity" do
        post user_session_path, params: {
          user: {
            email: "test@example.com",
            password: "wrongpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with non-existent email" do
      it "does not sign in user" do
        post user_session_path, params: {
          user: {
            email: "nobody@example.com",
            password: "password123"
          }
        }

        expect(controller.current_user).to be_nil
      end
    end
  end

  describe "DELETE /users/sign_out" do
    let!(:user) { create(:user) }

    context "when signed in" do
      before { sign_in user }

      it "signs out the user" do
        delete destroy_user_session_path

        expect(controller.current_user).to be_nil
      end

      it "redirects to root" do
        delete destroy_user_session_path

        expect(response).to redirect_to(root_path)
      end
    end

    context "when not signed in" do
      it "redirects without error" do
        delete destroy_user_session_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /users/sign_in" do
    context "when already signed in" do
      let!(:user) { create(:user) }

      before { sign_in user }

      it "redirects to root" do
        get new_user_session_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
