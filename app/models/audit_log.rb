
class AuditLog < ApplicationRecord
  belongs_to :user

  # validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :action, presence: true
  validates :entity_type, presence: true
  validates :entity_id, presence: true, numericality: { only_integer: true }
  validates :timestamp, presence: true
  # end for validations

  class << self
  end
end
