module Api::V1::PracticeQuestions
  class ConversionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: ConversionOptionSerializer)
    end
  end
end