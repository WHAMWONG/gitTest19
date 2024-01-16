
module Api
  class TodosController < Api::BaseController
    include ActiveStorage::SetCurrent
    before_action :doorkeeper_authorize!
    before_action :set_todo, only: [:create_attachment]
    before_action :authorize_attachment_creation, only: [:create_attachment]

    def create
      service = TodoService::Create.new(todo_params.merge(user_id: current_resource_owner.id))
      if service.valid?
        todo = service.call
        if todo
          # Check for attachments and process them if any
          if params[:attachments].present?
            params[:attachments].each do |attachment|
              todo.attachments.create!(file: attachment)
            end
            # Include attachment information in the response
            attachments = todo.attachments.map do |attachment|
              { id: attachment.id, file: attachment.file.blob.filename.to_s, created_at: attachment.created_at.iso8601 }
            end
            render json: { status: 201, todo: todo.as_json(include: :attachments), attachments: attachments }, status: :created
          else
            render json: { status: 201, todo: todo.as_json(include: :attachments) }, status: :created
          end
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

    def create_attachment
      if params[:file].blank?
        render json: { error: "File is required." }, status: :bad_request
        return
      end

      attachment = @todo.attachments.create(file: params[:file])

      if attachment.persisted?
        render json: {
          status: 201,
          attachment: {
            id: attachment.id,
            todo_id: attachment.todo_id,
            file: attachment.file.blob.filename.to_s,
            created_at: attachment.created_at.iso8601
          }
        }, status: :created
      else
        render json: { errors: attachment.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def set_todo
      @todo = Todo.find_by(id: params[:todo_id])
      render json: { error: "Todo item not found." }, status: :not_found if @todo.nil?
    end

    def authorize_attachment_creation
      authorize @todo, policy_class: ApplicationPolicy
    end

    def todo_params
      params.permit(:user_id, :title, :description, :due_date, :category, :priority, :is_recurring, :recurrence, attachments: [])
    end

    def current_resource_owner
      # Assuming there's a method to find the current user based on the doorkeeper token
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
