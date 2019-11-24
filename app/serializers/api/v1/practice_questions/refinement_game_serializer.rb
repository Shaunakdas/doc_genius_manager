module Api::V1::PracticeQuestions
  class RefinementGameSerializer < PracticeGameSerializer
    attributes :title, :lives, :correct_count, :time, :sections, :content_report

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: RefinementQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "hint": 20
      }
    end

    def content_report
      ActiveModel::ArraySerializer.new(object.sub_questions, each_serializer: RefinementContentSerializer)
    end
  end
end