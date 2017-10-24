class RegionPercentileScore < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
  belongs_to :region
end
