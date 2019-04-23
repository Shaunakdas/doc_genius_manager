module Api::V1
  class GameHolderDetailSerializer < AcadEntitySerializer
    attributes :id, :name, :slug, :sequence, :game, :image_url
    has_one :game, serializer: GameSerializer
  end
end
