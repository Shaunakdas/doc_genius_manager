module Api::V1::PracticeQuestions
  class EstimationQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :tips, :hint, :solution, :number_line

    def options
      
    end

    def hint
      object.question.solution
    end

    def answer
      EstimationAnswerSerializer.new(object.correct_game_options[0]).as_json[:estimation_answer]
    end

    def number_line
      {
        mode: object.question.mode,
        _mode: "round,round_addition,round_subtraction,round_multiplication,predecessor,successor,addition,subtraction,multiplication,addition_commutativity",
        marker_gaps:  MarkerGapSerializer.new(object.question.marker_gap).as_json[:marker_gap],
        display: ActiveModel::ArraySerializer.new(object.incorrect_game_options, each_serializer: EstimationOptionSerializer),
        answer: EstimationAnswerSerializer.new(object.correct_game_options[0]).as_json[:estimation_answer]
      }
    end
  end
end