module Api::V1
  class GameHolderSerializer < AcadEntitySerializer
    attributes :id, :title, :name, :slug, :sequence, :game, :image_url, :enabled
    has_one :game, serializer: GameSerializer

    def question_input
      object.get_questions
    end
  end
end
