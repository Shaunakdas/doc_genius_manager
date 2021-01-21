module Api::V1
  class QuizBlockSerializer < AcadEntitySerializer
    attribute :display_block
    def display_block
      game_holders = object.sample_game_holders
      if !scope.nil? && !scope[:standard_id].nil?
        standard = Standard.where(slug: scope[:standard_id]).first
        game_holders = object.standard_game_holders(standard) if !standard.nil?
      end
      {
        title: object.title,
        url_suffix: object.url_suffix,
        quizzes: ActiveModel::ArraySerializer.new(game_holders, each_serializer: QuizSerializer)
      }
    end
  end
end
