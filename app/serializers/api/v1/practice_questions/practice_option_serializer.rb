module Api::V1::PracticeQuestions
  class PracticeOptionSerializer < ActiveModel::Serializer
    attributes :id, :entity_type

    def entity_type
      "game_option"
    end

    def type
      object.option.value_type
    end

    def display
      object.option.display
    end

    def answer
      object.option.display
    end

    def correct
      object.option.correct
    end

    def _correct
      "bool"
    end

    def index
      object.option.display_index
    end

    def tips
      object.option.tip
    end

    def value
      object.option.value
    end

    def upper
      object.option.upper
    end

    def lower
      object.option.lower.nil? ? "" : object.option.lower
    end

    def sequence
      object.option.sequence
    end

    def _sequence
      "sequence,1,2,3,4,5,6"
    end

    def after_attempt
      object.option.after_attempt
    end

    def hint
      object.option.hint
    end

    def title
      object.option.title
    end

  end
end