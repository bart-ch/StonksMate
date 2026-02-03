require "rails_helper"

RSpec.describe Users::App do
  describe ".find" do
    it "returns the user with the given id" do
      user = create(:user)

      found_user = described_class.find(user.id)

      expect(found_user).to eq(user)
    end
  end
end
