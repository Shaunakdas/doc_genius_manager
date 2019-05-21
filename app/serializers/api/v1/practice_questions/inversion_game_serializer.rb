module Api::V1::PracticeQuestions
  class InversionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :entry_sequence, :entry_delay, :question,  :pairs

    def question
      object.game_questions[0].question.display
    end

    def pairs
      ActiveModel::ArraySerializer.new(object.game_questions.first.sub_questions, each_serializer: InversionQuestionSerializer)
    end

    def pair_count
      object.game_questions.length
    end

  end
end