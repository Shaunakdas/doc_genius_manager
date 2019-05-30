module Api::V1::PracticeQuestions
  class TippingGameSerializer < PracticeGameSerializer
    attributes :title, :lives, :correct_count, :time, :sections, :content_report

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: TippingQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "hint": 20
      }
    end

    def content_report
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: TippingContentSerializer)
    end
  end
end