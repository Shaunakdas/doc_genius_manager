module Api::V1::PracticeQuestions
  class ProportionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :faces

    def faces
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: ProportionOptionSerializer)
    end
  end
end