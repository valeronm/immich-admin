class Asset < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum :type, image: "IMAGE", video: "VIDEO", audio: "AUDIO", other: "OTHER"
  enum :status, active: "active", trashed: "trashed", deleted: "deleted"
  enum :visibility, archived: "archive", timeline: "timeline", hidden: "hidden", locked: "locked"

  belongs_to :owner, class_name: "User", foreign_key: :ownerId
  belongs_to :live_photo_video, class_name: "Asset", foreign_key: :livePhotoVideoId, optional: true

  has_many :files, foreign_key: :assetId, class_name: "AssetFile"
  has_many :faces, foreign_key: :assetId, class_name: "AssetFace"
  has_one :exif, foreign_key: :assetId
  has_one :asset_job_status, foreign_key: :assetId

  has_and_belongs_to_many :albums,
                          join_table: :albums_assets_assets,
                          foreign_key: :assetsId,
                          association_foreign_key: :albumsId
  has_and_belongs_to_many :tags,
                          join_table: :tag_asset,
                          foreign_key: :assetsId,
                          association_foreign_key: :tagsId

  scope :favorite, -> { where(isFavorite: true) }
  scope :external, -> { where(isExternal: true) }
  scope :offline, -> { where(isOffline: true) }

  scope :live_photo, -> { where.not(livePhotoVideoId: nil) }
  scope :with_duplicates, -> { where.not(duplicateId: nil) }

  def duplicates
    Asset.where(duplicateId:) if duplicateId
  end
end
