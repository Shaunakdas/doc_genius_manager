module Api::V1
  class GameLevelVictoryCardSerializer < ActiveModel::Serializer
    attributes :id, :current_count
    has_one :victory_card, serializer: VictoryCardSerializer
  end
end
