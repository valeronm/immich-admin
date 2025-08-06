class TagClosure < ApplicationRecord
  self.table_name = "tag_closure"

  belongs_to :ancestor, class_name: "Tag", foreign_key: :id_ancestor
  belongs_to :descendant, class_name: "Tag", foreign_key: :id_descendant
end
