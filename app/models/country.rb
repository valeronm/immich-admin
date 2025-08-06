class Country < ApplicationRecord
  self.table_name = "naturalearth_countries"
  self.inheritance_column = :_type_disabled
end
