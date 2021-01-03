module Api::V1
  class QuizBlockSerializer < AcadEntitySerializer
    attribute :display_block
    def display_block
      {
        title: object.title,
        url_suffix: object.url_suffix,
        quizzes: ActiveModel::ArraySerializer.new(object.sample_game_holders, each_serializer: QuizSerializer)
      }
    end
  end
end
