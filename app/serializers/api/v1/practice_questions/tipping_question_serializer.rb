module Api::V1::PracticeQuestions
  class TippingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :bubble, :question, :tip, :hint, :correct_option_count, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: TippingOptionSerializer)
    end

    def bubble
      object.question.title
    end
  end
end