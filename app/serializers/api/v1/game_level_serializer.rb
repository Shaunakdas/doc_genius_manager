module Api::V1
  class GameLevelSerializer < AcadEntitySerializer
    attributes :id, :title, :sub_title, :name, :slug, :sequence, :game, :image_url, :enabled, :score_small
    has_one :game, serializer: GameSerializer

    def question_input
      object.game_holder.get_questions
    end

    def benefits
      [
        "First Benefit",
        "Second Benefit"
      ]
    end

    def score_small
      {
        highest: 10000,
        difficulty: {
          current: 100,
          max: 400
        },
        ranking: 50.24
      }
    end

    def score
      {
        highest: 10000,
        difficulty: {
          current: 100,
          max: 400
        },
        time_trained: 2100,
        wins: 8,
        top: [
          12000,
          11000,
          9000,
          8000,
          7000,
          6000
        ],
        recent: [
          6000,
          11000,
          7000,
          8000,
          9000,
          12000
        ]
      }
    end

    def sub_title
      object.game_holder.acad_entity.chapter.name if object.game_holder.acad_entity
    end
  end
end
