module Api::V1::PracticeQuestions
  class EstimationQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :tips, :hint, :mode, :marker_gap, :options, :answer

    def options
      ActiveModel::ArraySerializer.new(object.incorrect_game_options, each_serializer: EstimationOptionSerializer)
    end

    def hint
      object.question.solution
    end

    def answer
      EstimationAnswerSerializer.new(object.correct_game_options[0]).as_json[:estimation_answer]
    end
  end
end