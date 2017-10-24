class AcadEntityScore < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
  belongs_to :session_score
end
