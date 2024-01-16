class Attachment < ApplicationRecord
  belongs_to :todo

  has_many_attached :file, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
