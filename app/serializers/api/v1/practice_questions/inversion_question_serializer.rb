module Api::V1::PracticeQuestions
  class InversionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :hint, :options, :option_refs, :powerup

    def options
      object.game_options.map{|x|x.option.display}
      # ActiveModel::ArraySerializer.new(object.game_options, each_serializer: InversionOptionSerializer)
    end

    def option_refs
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: InversionOptionSerializer)
    end

    def hint
      object.question.solution
    end

    def powerup
      nil
    end
  end
end