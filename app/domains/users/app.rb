module Users
  class App
    def self.find(id)
      Repository.new.find(id)
    end
  end

  private_constant :Repository
end
