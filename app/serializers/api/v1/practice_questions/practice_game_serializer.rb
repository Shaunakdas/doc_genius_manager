module Api::V1::PracticeQuestions
  class PracticeGameSerializer < ActiveModel::Serializer
    attributes :id, :entity_type

    def entity_type
      "game_holder"
    end
    
    def title
      object.game.name
    end

    def time
      {
        "total": 120
      }
    end

    def correct_count
      4
    end

    def lives
      3
    end

    def entry_sequence
      [3,3,8,1,1,1,1,1,1]
    end

    def entry_delay
      4
    end

    def minimum_correct_count
      3
    end
  end
end