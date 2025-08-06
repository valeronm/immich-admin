class AssetFile < ApplicationRecord
  self.table_name = "asset_file"
  self.inheritance_column = :_type_disabled

  enum :type, preview: "preview", thumbnail: "thumbnail", fullsize: "fullsize"

  belongs_to :asset, foreign_key: :assetId
end
