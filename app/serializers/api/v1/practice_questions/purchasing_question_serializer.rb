module Api::V1::PracticeQuestions
  class PurchasingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :mode, :title, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: PurchasingOptionSerializer)
    end
  end
end