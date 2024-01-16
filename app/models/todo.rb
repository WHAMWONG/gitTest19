class Todo < ApplicationRecord
  has_many :attachments, dependent: :destroy

  belongs_to :user

  enum priority: %w[low medium high], _suffix: true
  enum recurrence: %w[daily weekly monthly], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
