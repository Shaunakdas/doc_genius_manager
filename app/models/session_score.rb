class SessionScore < ApplicationRecord
  belongs_to :game_session
  has_many :acad_entity_scores
end
