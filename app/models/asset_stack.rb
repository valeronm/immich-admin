class AssetStack < ApplicationRecord
  self.table_name = "asset_stack"

  belongs_to :owner, class_name: "User", foreign_key: :ownerId
  belongs_to :primary_asset, class_name: "Asset", foreign_key: :primaryAssetId

  has_many :assets, foreign_key: :stackId
end
