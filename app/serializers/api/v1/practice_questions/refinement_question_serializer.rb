module Api::V1::PracticeQuestions
  class RefinementQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :blocks

    def blocks
      ActiveModel::ArraySerializer.new(object.sub_questions, each_serializer: RefinementBlockSerializer)
    end
  end
end