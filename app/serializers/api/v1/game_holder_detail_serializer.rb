module Api::V1
  class GameHolderDetailSerializer < AcadEntitySerializer
    attributes :id, :name, :slug, :sequence, :game, :image_url, :question_input
    has_one :game, serializer: GameSerializer

    def question_input
      object.get_questions
    end
  end
end
