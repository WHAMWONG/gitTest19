class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    service = TodoService::Create.new(todo_params.merge(user_id: current_resource_owner.id))
    if service.valid?
      todo = service.call
      if todo
        render json: { status: 201, todo: todo.as_json }, status: :created
      else
        render json: { errors: ['An unexpected error occurred on the server.'] }, status: :internal_server_error
      end
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['User not found.'] }, status: :bad_request
  end

  def validate
    validator = TodoService::Create.new(todo_params.merge(user_id: current_resource_owner.id))

    if validator.valid?
      render json: { status: 200, message: "No conflicts found." }, status: :ok
    else
      error_message = validator.errors.full_messages.to_sentence
      case error_message
      when /Title already exists/
        render json: { error: error_message }, status: :conflict
      when /Due date conflicts with an existing todo/
        render json: { error: error_message }, status: :conflict
      when /The request body or parameters are in the wrong format/
        render json: { error: error_message }, status: :unprocessable_entity
      else
        render json: { error: error_message }, status: :bad_request
      end
    end
  end

  private

  def todo_params
    params.permit(:user_id, :title, :description, :due_date, :category, :priority, :is_recurring, :recurrence)
  end

  def current_resource_owner
    # Assuming there's a method to find the current user based on the doorkeeper token
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
