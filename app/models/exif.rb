class Exif < ApplicationRecord
  self.table_name = "exif"

  belongs_to :asset, foreign_key: :assetId
end
