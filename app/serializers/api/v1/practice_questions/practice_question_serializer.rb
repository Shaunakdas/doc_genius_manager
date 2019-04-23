module Api::V1::PracticeQuestions
  class PracticeQuestionSerializer < ActiveModel::Serializer
    attributes :id
    def mode
      object.question.mode
    end

    def question
      object.question.display
    end

    def answer
      object.question.solution
    end

    def hint
      object.question.hint
    end

    def tips
      object.question.tip
    end
  end
end