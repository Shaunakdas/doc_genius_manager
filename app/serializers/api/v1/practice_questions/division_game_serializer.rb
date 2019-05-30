module Api::V1::PracticeQuestions
  class DivisionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections, :content_report

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: DivisionQuestionSerializer)
    end

    def content_report
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: DivisionContentSerializer)
    end
  end
end