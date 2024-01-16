
class Attachment < ApplicationRecord
  belongs_to :todo

  has_one_attached :file, dependent: :destroy

  # validations
  validates :file, presence: true
  validates :file, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                   size: { less_than_or_equal_to: 100.megabytes }
  # end for validations

  class << self
  end
end
