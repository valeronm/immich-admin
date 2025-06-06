class Tag < ApplicationRecord
  belongs_to :user, foreign_key: :userId
  belongs_to :parent, class_name: "Tag", foreign_key: :parentId

  has_many :children, class_name: "Tag", foreign_key: :parentId

  has_and_belongs_to_many :assets,
                          join_table: :tag_asset,
                          foreign_key: :tagsId,
                          association_foreign_key: :assetsId

  scope :roots, -> { where(parentId: nil) }
  scope :simple, -> { roots.where.missing(:children) }
  scope :tree, -> { roots.where.associated(:children) }
end
