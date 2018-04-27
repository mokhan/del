  class UserRepository
    def initialize
      @users = Set.new
    end

    def create(item)
      @users << User.new(item.attributes)
    end
  end
