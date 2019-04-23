module Api::V1::PracticeQuestions
  class ProportionSectionSerializer < PracticeQuestionSerializer
    attributes :id, :blocks

    def blocks
      ActiveModel::ArraySerializer.new(object.sub_questions, each_serializer: ProportionQuestionSerializer)
    end
  end
end