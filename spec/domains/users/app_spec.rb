require "rails_helper"

RSpec.describe Users::App do
  describe "#current" do
    it "returns the user passed during initialization" do
      user = create(:user)
      app = described_class.new(user: user)

      expect(app.current).to eq(user)
    end
  end

  describe ".find" do
    it "returns the user with the given id" do
      user = create(:user)

      found_user = described_class.find(user.id)

      expect(found_user).to eq(user)
    end

    it "raises an error for non-existent user" do
      expect { described_class.find(999) }.to raise_error(StandardError, /User not found/)
    end
  end
end
