class Notification < ApplicationRecord
  self.table_name = "notification"

  belongs_to :user, foreign_key: :userId
end
