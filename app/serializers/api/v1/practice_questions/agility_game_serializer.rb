module Api::V1::PracticeQuestions
  class AgilityGameSerializer < PracticeGameSerializer
    attributes :title, :lives, :correct_count, :time, :sections

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: AgilityQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "hint": 20
      }
    end
  end
end