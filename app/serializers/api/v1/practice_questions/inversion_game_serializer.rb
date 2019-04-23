module Api::V1::PracticeQuestions
  class InversionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :pairs, :entry_sequence, :entry_delay

    def pairs
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: InversionQuestionSerializer)
    end

    def entry_sequence
      [3,3,8,1,1,1,1,1,1]
    end

    def entry_delay
      4
    end

    def pair_count
      object.game_questions.length
    end

  end
end