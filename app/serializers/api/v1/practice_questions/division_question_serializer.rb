module Api::V1::PracticeQuestions
  class DivisionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :mode, :question, :answer, :hint, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: DivisionOptionSerializer)
    end
  end
end