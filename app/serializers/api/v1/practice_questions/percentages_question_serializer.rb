module Api::V1::PracticeQuestions
  class PercentagesQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :tips, :hint, :answer, :numpad

    def numpad
      answer.tr("0-9", "").split("")
    end
  end
end