class TodoPolicy < ApplicationPolicy
  def attach?
    # Assuming 'user' is the current authenticated user and 'record' is the todo item
    # Check if the user is the owner of the todo item
    user.todos.include?(record)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
