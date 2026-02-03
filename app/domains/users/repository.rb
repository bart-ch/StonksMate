module Users
  class Repository
    def find(id)
      User.find(id)
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::NotFound, "User not found with id: #{id}"
    end
  end
end
