class Album < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "ownerId"

  has_and_belongs_to_many :assets,
                          join_table: :albums_assets_assets,
                          foreign_key: :albumsId,
                          association_foreign_key: :assetsId
  has_and_belongs_to_many :shared_users,
                          class_name: "User",
                          join_table: :albums_shared_users_users,
                          foreign_key: :albumsId,
                          association_foreign_key: :usersId

  scope :active, -> { where(deletedAt: nil) }
end
