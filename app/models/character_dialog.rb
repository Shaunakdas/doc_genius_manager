class CharacterDialog < ApplicationRecord
  belongs_to :character_discussion
  belongs_to :character
  belongs_to :left_weapon
  belongs_to :right_weapon
end
