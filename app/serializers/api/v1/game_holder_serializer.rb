module Api::V1
  class GameHolderSerializer < AcadEntitySerializer
    attributes :id, :title, :sub_title, :name, :slug, :sequence, :game, :image_url, :enabled, :score_small
    has_one :game, serializer: GameSerializer

    def question_input
      object.get_questions
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
      object.acad_entity.chapter.name
    end

    def score_algo
      return {
        limiter: limiter,
        marks: marks,
        end_screen: end_screen
      } if object.score_structure
      return nil
    end

    def limiter
      {
        time: {
          per_question: object.score_structure.limiter_time_question,
          per_game: object.score_structure.limiter_time_game
        },
        options: object.score_structure.limiter_option,
        questions: object.score_structure.limiter_question,
        lives: object.score_structure.limiter_lives
      }
    end

    def marks
      {
        normal:{
          attempt: object.score_structure.marks_normal_attempt,
          time: object.score_structure.marks_normal_time
        },
        speedy: {
          time_limit: object.score_structure.marks_speedy_time_limit,
          max_marks: object.score_structure.marks_speedy_max
        },
        complete_set: object.score_structure.marks_complete_set,
        remaining_lives: object.score_structure.marks_remaining_lives,
        actual_answer: object.score_structure.marks_actual_answer,
        consistency_bonus: object.score_structure.marks_consistency_bonus,
        remaining_time: object.score_structure.marks_remaining_time
      }
    end

    def end_screen
      {
        star_thresholds:{
          two_star: object.score_structure.star_threshold_2,
          three_star: object.score_structure.star_threshold_3
        },
        display: {
          reports: {
            accuracy: object.score_structure.display_report_accuracy,
            content: object.score_structure.display_report_content,
          },
          remaining_lives: object.score_structure.display_remaining_lives,
          speedy_answers: object.score_structure.display_speedy_answer,
          perfect_sets: object.score_structure.display_perfect_set,
          longest_streaks: object.score_structure.display_longest_streak,
          accurate_answer: object.score_structure.display_accurate_answer,
          errors: object.score_structure.display_errors,
          remaining_time: object.score_structure.display_remaining_time 
        }
      }
    end
  end
end
