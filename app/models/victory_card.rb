class VictoryCard < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true, optional: true
  has_one :game_level_victory_card
  def self.get_default
    return VictoryCard.last if VictoryCard.all.count > 0
    victory_card = VictoryCard.new(name: "Default VictoryCard", slug: "default-victory-card-1")
    return victory_card if victory_card.save!
  end
end
