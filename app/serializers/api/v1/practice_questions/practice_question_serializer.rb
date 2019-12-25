module Api::V1::PracticeQuestions
  class PracticeQuestionSerializer < ActiveModel::Serializer
    attributes :id, :entity_type, :is_parent_question

    def is_parent_question
      object.sub_questions.length > 0
    end

    def entity_type
      "game_question"
    end

    def mode
      object.question.mode
    end

    def _mode
      "dropdown"
    end
    
    def setup
      object.question.setup
    end

    def title
      object.question.title
    end

    def question
      object.question.display
    end

    def answer
      object.question.solution
    end

    def _answer
      "bool"
    end

    def hint_content
      object.question.hint
    end

    def solution
      object.question.solution
    end

    def hint
      object.question.hint
    end

    def tips
      object.question.tip
    end
    
    def tip
      object.question.tip
    end

    def correct_option_count
      4
    end

    def _correct_option_count
      "positive_integer"
    end

    def type
      object.question.value_type
    end

    def _type
      "dropdown,sector,math,text"
    end

    def marker_gap
      MarkerGapSerializer.new(object.question.marker_gap).as_json[:marker_gap]
    end

    def section_question
      object.question.title
    end

    def steps
      object.question.steps
    end
  end
end