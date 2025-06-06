class SmartSearch < ApplicationRecord
  self.table_name = "smart_search"

  belongs_to :asset, foreign_key: :assetId
  has_neighbors :embedding
end
