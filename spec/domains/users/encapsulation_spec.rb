require "rails_helper"

RSpec.describe "Users domain encapsulation" do
  describe "private constants" do
    it "does not expose Repository outside the domain" do
      expect { Users::Repository }.to raise_error(NameError)
    end

    it "does not expose Exceptions outside the domain" do
      expect { Users::Exceptions }.to raise_error(NameError)
    end
  end

  describe "public classes" do
    it "exposes App as the facade" do
      expect(Users::App).to be_a(Class)
    end

    it "exposes User for Devise integration" do
      expect(Users::User).to be < ApplicationRecord
    end
  end
end
