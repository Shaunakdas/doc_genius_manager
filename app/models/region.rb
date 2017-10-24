class Region < DisplayEntity
  has_many :sub_regions, class_name: 'Region', foreign_key: 'parent_region_id'
  belongs_to :parent_region, class_name: 'Region', optional: true
end
