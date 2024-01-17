class User < ApplicationRecord
  has_many :todos, dependent: :destroy
  has_many :audit_logs, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
