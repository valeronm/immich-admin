class Session < ApplicationRecord
  self.table_name = "session"

  belongs_to :user, foreign_key: :userId
end
