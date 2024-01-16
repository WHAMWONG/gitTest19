
class Todo < ApplicationRecord
  has_many :attachments, dependent: :destroy
  has_many_attached :files

  belongs_to :user

  enum priority: %w[low medium high], _suffix: true
  enum recurrence: %w[daily weekly monthly], _suffix: true

  # validations
  validates :files, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes },
                    limit: { max: 10 }
  # end for validations

  class << self
  end
end
