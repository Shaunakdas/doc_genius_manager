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
  end
end