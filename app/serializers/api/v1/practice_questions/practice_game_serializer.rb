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
  end
end