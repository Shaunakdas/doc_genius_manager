module Api::V1::PracticeQuestions
  class TippingContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title

    def title
      "#{object.game_question.question.display} : #{object.option.display}"
    end

    def sub_title
      object.option.correct.to_s
    end
  end
end