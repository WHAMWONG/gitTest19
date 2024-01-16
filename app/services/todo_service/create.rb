
module TodoService
  class Create
    include ActiveModel::Validations

    validates :title, presence: true
    validate :due_date_in_future, :unique_title_for_user, :valid_priority, :valid_recurrence

    def initialize(user_id:, title:, description: nil, due_date:, category: nil, priority:, is_recurring: false, recurrence: nil, attachments_params: [])
      @user = User.find(user_id)
      @title = title
      @description = description
      @due_date = due_date
      @category = category
      @priority = priority
      @is_recurring = is_recurring
      @recurrence = recurrence
      @attachments_params = attachments_params
    end

    def call
      return unless valid?

      attachments = [] # Placeholder for attachment handling logic
      Todo.transaction do
        todo = @user.todos.create!(
          title: @title,
          description: @description,
          due_date: @due_date,
          category: @category,
          priority: @priority,
          is_recurring: @is_recurring,
          recurrence: @recurrence
        )

        # Handle attachments here if applicable
        # Assuming 'attachments_params' is an array of ActionDispatch::Http::UploadedFile objects
        @attachments_params.each do |attachment_param|
          attachment = todo.attachments.create!(file: attachment_param)
          attachments << attachment
        end unless @attachments_params.blank?

        { todo: todo, attachments: attachments }
      end
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.to_sentence
    end

    private

    def due_date_in_future
      errors.add(:due_date, I18n.t('activerecord.errors.messages.datetime_in_future')) if @due_date.past?
    end

    def unique_title_for_user
      existing_todo = @user.todos.find_by(title: @title)
      errors.add(:title, I18n.t('activerecord.errors.messages.taken')) if existing_todo.present?
    end

    def valid_priority
      errors.add(:priority, I18n.t('activerecord.errors.messages.in', count: Todo.priorities.keys.join(', '))) unless Todo.priorities.keys.include?(@priority)
    end

    def valid_recurrence
      if @is_recurring && !Todo.recurrences.keys.include?(@recurrence)
        errors.add(:recurrence, I18n.t('activerecord.errors.messages.in', count: Todo.recurrences.keys.join(', ')))
      end
    end
  end
end
