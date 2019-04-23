module Api::V1::PracticeQuestions
  class DivisionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections

    def sections
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: DivisionQuestionSerializer)
    end
  end
end