class SharedLink < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum :type, album: "ALBUM", individual: "INDIVIDUAL"

  belongs_to :user, foreign_key: :userId
  belongs_to :album, foreign_key: :albumId, optional: true

  has_and_belongs_to_many :assets,
                          join_table: :shared_link__asset,
                          foreign_key: :sharedLinksId,
                          association_foreign_key: :assetsId
end
