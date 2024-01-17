module AuditLogService
  class Create
    include ActiveModel::Validations

    validates :user_id, :action, :entity_type, :entity_id, :timestamp, presence: true

    def initialize(user_id:, action:, entity_type:, entity_id:, timestamp:)
      @user_id = user_id
      @action = action
      @entity_type = entity_type
      @entity_id = entity_id
      @timestamp = timestamp
    end

    def call
      audit_log = AuditLog.new(
        user_id: @user_id,
        action: @action,
        entity_type: @entity_type,
        entity_id: @entity_id,
        timestamp: @timestamp
      )

      if audit_log.save
        'Deletion action has been logged.'
      else
        Rails.logger.error(audit_log.errors.full_messages)
        'Error logging the deletion action.'
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e.message)
      'Error logging the deletion action.'
    end
  end
end
