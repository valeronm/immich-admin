class UserMetadata < ApplicationRecord
  self.table_name = "user_metadata"

  KEYS = [
    PREFERENCES = "preferences".freeze
  ].freeze

  belongs_to :user, foreign_key: :userId
end
