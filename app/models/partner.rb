class Partner < ApplicationRecord
  belongs_to :shared_by, class_name: "User", foreign_key: :sharedById
  belongs_to :shared_with, class_name: "User", foreign_key: :sharedWithId
end
