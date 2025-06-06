class Library < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "ownerId"
end
