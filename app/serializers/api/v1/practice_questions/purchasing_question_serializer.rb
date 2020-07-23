module Api::V1::PracticeQuestions
  class PurchasingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :hint_content, :solution, :hint_structure, :mode, :_mode, :title, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: PurchasingOptionSerializer)
    end

    def _mode
      "dropdown,army,fruit,education,distance,counting,age,food,time,money,petrol"
    end

    def solution
      object.question.solution
    end

    def hint_structure
      Question.parse_hint_structure(object.question.solution,object.question.prefix_url)
    end
  end
end