module Api::V1::PracticeQuestions
  class PracticeQuestionSerializer < ActiveModel::Serializer
    attributes :id
    def mode
      object.question.mode
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

    def type
      object.question.value_type
    end

    def marker_gap
      MarkerGapSerializer.new(object.question.marker_gap).as_json[:marker_gap]
    end

    def section_question
      object.question.title
    end
  end
end