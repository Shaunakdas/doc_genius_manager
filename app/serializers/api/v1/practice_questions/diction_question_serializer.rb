module Api::V1::PracticeQuestions
  class DictionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :answer

    def answer
      object.game_options.first.option.correct
    end

    def hint
      {
        question: object.question.hint,
        solution: object.question.solution
      }
    end
  end
end