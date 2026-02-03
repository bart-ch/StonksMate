module Users
  class App
    def initialize(user:)
      @user = user
    end

    def current
      @user
    end

    def self.find(id)
      Repository.new.find(id)
    end
  end

  private_constant :Repository
  private_constant :Exceptions
end
