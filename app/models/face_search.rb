class FaceSearch < ApplicationRecord
  self.table_name = "face_search"

  belongs_to :asset_face, foreign_key: :faceId
  has_neighbors :embedding
end
