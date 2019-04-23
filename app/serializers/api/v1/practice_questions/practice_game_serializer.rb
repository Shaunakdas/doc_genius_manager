module Api::V1::PracticeQuestions
  class PracticeGameSerializer < ActiveModel::Serializer
    attributes :id
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
  end
end