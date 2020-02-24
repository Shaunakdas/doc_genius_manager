module Api::V1::PracticeQuestions
  class EstimationGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections

    def sections
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: EstimationQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "hint": 20
      }
    end
  end
end