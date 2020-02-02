class VictoryCard < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
end
