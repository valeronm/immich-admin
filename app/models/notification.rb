class Notification < ApplicationRecord
  belongs_to :user, foreign_key: :userId
end
