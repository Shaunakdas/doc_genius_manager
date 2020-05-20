module Api::V1::PracticeQuestions
  class PercentagesQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :tips, :hint,:hint_content, :hint_structure, :answer, :numpad, :post_submit_text, :mode

    def numpad
      answer.tr("0-9", "").split("")
    end

    def _numpad
      "dropdown,+,.,-"
    end

    def tips
      object.question.tip.nil? ? [] : object.question.tip.split('\\n')
    end
  end
end