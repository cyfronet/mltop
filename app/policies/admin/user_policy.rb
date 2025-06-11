module Admin
  class UserPolicy
   def index?
      admin?
   end
  end
end
