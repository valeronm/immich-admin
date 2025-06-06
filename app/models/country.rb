class Country < ApplicationRecord
  self.inheritance_column = :_type_disabled
  self.table_name = "naturalearth_countries"
end
