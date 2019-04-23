module Api::V1::PracticeQuestions
  class TippingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :title, :question, :tips, :hint, :correct_option_count, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: TippingOptionSerializer)
    end
  end
end