class AssetExif < ApplicationRecord
  self.table_name = "asset_exif"

  belongs_to :asset, foreign_key: :assetId
end
