module Api::V1
  class GameEndSerializer < ActiveModel::Serializer
    attributes :id,:start, :finish, :difficulty_block, :proficiency_block

    has_one :attempt_score, serializer: AttemptScoreSerializer

    def difficulty_block
      if object.game_holder.id.even?
        return nil
      else
        hike =  rand(1..5)
        return {
          header: "Next Difficulty".upcase,
          current: 80,
          next: 80 + hike,
          hike: hike,
          info: "Game Difficulty levels range from 1 to 400. The higher the level, the tougher the content. \n Difficulty Levels changes after each game back to your performance."
        }
      end
    end

    def proficiency_block
      if object.game_holder.id.even?
        return nil
      else
        hike =  rand(1..5)
        return {
          header: "DRONA GRADE".upcase,
          icon: "M",
          title: "Math EPQ earned",
          sub_title: "Procificiency Level".upcase,
          info: "Drona Grade tracks your performance in all chapters of Math. \n Drona Grade ranges from 0-1000 and is based on game performance, consistent training and game variety"
        }
      end
    end
  end
end