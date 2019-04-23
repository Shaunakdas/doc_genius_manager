module Api::V1::PracticeQuestions
  class InversionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :answer, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: InversionOptionSerializer)
    end
  end
end