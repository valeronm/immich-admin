class Memory < ApplicationRecord
  self.table_name = "memory"
  self.inheritance_column = :_type_disabled

  enum :type, on_this_day: "on_this_day"

  belongs_to :owner, class_name: "User", foreign_key: :ownerId

  has_and_belongs_to_many :assets,
                          join_table: :memory_asset,
                          foreign_key: :memoriesId,
                          association_foreign_key: :assetsId

  scope :saved, -> { where(isSaved: true) }
  scope :unseen, -> { where(seenAt: nil) }
end
