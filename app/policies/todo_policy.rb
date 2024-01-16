
class TodoPolicy < ApplicationPolicy
  def attach?
    user.todos.include?(record)
  end

  def create_attachment?
    user.todos.include?(record)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
