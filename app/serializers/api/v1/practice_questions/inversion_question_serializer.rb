module Api::V1::PracticeQuestions
  class InversionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :hint, :options

    def options
      object.game_options.map{|x|x.option.display}
      # ActiveModel::ArraySerializer.new(object.game_options, each_serializer: InversionOptionSerializer)
    end

    def hint
      object.question.solution
    end
  end
end