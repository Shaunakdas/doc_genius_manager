module Api::V1::PracticeQuestions
  class DictionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :answer, :hint_content, :solution

    def answer
      object.game_options.first.option.correct if object.game_options.count > 0
    end

    def hint
      {
        question: object.question.hint,
        solution: object.question.solution
      }
    end
  end
end