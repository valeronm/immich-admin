class AssetFace < ApplicationRecord
  self.table_name = "asset_face"

  enum :sourceType, machine_learning: "machine-learning", exif: "exif", manual: "manual"

  belongs_to :asset, foreign_key: :assetId
  belongs_to :person, foreign_key: :personId

  has_one :face_search, foreign_key: :faceId
end
