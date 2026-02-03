module Users
  class Repository
    def find(id)
      User.find(id)
    end
  end
end
