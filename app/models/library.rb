class Library < ApplicationRecord
  self.table_name = "library"

  belongs_to :owner, class_name: "User", foreign_key: "ownerId"
end
