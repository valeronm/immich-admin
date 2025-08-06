class ApiKey < ApplicationRecord
  self.table_name = "api_key"

  belongs_to :user, foreign_key: :userId
end
