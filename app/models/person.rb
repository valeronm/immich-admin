class Person < ApplicationRecord
  self.table_name = "person"

  belongs_to :owner, class_name: "User", foreign_key: :ownerId
  belongs_to :face_asset, class_name: "Asset", foreign_key: :faceAssetId

  has_many :asset_faces, foreign_key: :personId
  has_many :assets, through: :asset_faces

  scope :favorite, -> { where(isFavorite: true) }
  scope :hidden, -> { where(isHidden: true) }
end
