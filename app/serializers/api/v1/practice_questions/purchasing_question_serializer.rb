module Api::V1::PracticeQuestions
  class PurchasingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :hint_content, :solution, :mode, :_mode, :title, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: PurchasingOptionSerializer)
    end

    def _mode
      "dropdown,army,fruit,education,distance,counting,age,food,time,money,petrol"
    end

    def solution
      object.question.solution
    end
  end
end