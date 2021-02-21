module Api::V1
  class GameHolderSummarySerializer < AcadEntitySerializer
    attributes :id, :title, :name, :slug, :game, :image_url, :enabled
    has_one :game, serializer: GameSerializer
  end
end
