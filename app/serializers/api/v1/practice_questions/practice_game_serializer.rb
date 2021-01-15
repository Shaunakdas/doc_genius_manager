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

    def linked_game_questions
      if object.class.name == "GameLevel"
        return object.game_questions if object.game_questions.count > 0
        return object.game_holder.game_questions
      elsif object.class.name == "GameHolder"
        return object.game_questions.first(10)
      else
        return []
      end
    end

    def linked_sub_questions
      if object.class.name == "GameLevel"
        return object.sub_questions if object.sub_questions.count > 0
        return object.game_holder.sub_questions
      elsif object.class.name == "GameHolder"
        return object.sub_questions
      else
        return []
      end
    end
  end
end