class AssetJobStatus < ApplicationRecord
  self.table_name = "asset_job_status"

  belongs_to :asset, foreign_key: :assetId
end
