module Api::V1::PracticeQuestions
  class PercentagesGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: PercentagesQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "question": 20
      }
    end

  end
end