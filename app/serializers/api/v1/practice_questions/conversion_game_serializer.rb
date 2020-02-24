module Api::V1::PracticeQuestions
  class ConversionGameSerializer < PracticeGameSerializer
    attributes :title, :lives, :correct_count, :time, :sections

    def sections
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: ConversionQuestionSerializer)
    end

    def time
      {
        "total": 120,
        "section": 15
      }
    end
  end
end