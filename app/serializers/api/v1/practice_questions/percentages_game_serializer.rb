module Api::V1::PracticeQuestions
  class PercentagesGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections, :content_report

    def sections
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: PercentagesQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "question": 20
      }
    end

    def content_report
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: PercentagesContentSerializer)
    end

  end
end