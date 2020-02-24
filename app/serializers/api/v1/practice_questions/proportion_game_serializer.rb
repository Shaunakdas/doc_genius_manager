module Api::V1::PracticeQuestions
  class ProportionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :sections, :minimum_correct_count

    def sections
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: ProportionSectionSerializer)
    end

    def time
      {
        "total": 120,
        "hint": 20
      }
    end
  end
end