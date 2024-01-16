class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!

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
    params.permit(:title, :due_date)
  end
end
