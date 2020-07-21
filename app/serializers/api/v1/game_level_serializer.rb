module Api::V1
  class GameLevelSerializer < AcadEntitySerializer
    attributes :id, :title, :sub_title, :practice_mode, :nature_effect,:name, :slug, :sequence,
    :game, :image_url, :enabled, :score_small, :background_area, :star_count, :locked
    has_one :game, serializer: GameSerializer

    def question_input
      object.get_questions
    end
  
    def title
      return object.game_holder.title if object.title.nil?
      return object.title
    end

    def benefits
      return [
        "First Benefit",
        "Second Benefit"
      ] if object.benifits.count == 0
      return object.benifits.map { |r| r.explainer }
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

    def score_algo
      return object.score_structure.score_algo if object.score_structure
      return object.game_holder.score_structure.score_algo if object.game_holder.score_structure
      return nil
    end

    def background_area
      object.background_area
    end

    def star_count
      nil
    end

    def current
      nil
    end

    def locked
      nil
    end
  end
end
