module TodoService
  class Delete
    def initialize(user, todo_id)
      @user = user
      @todo_id = todo_id
    end

    def call
      todo = @user.todos.find_by(id: @todo_id)

      if todo.nil?
        raise StandardError.new "To-Do item could not be found or you don't have permission to delete it."
      end

      todo.destroy!

      AuditLog.create!(
        user_id: @user.id,
        action: 'delete',
        entity_type: 'todo',
        entity_id: @todo_id,
        timestamp: Time.current
      )

      "To-Do item has been successfully deleted."
    rescue StandardError => e
      e.message
    end
  end
end
