module Api::V1::PracticeQuestions
  class PracticeOptionSerializer < ActiveModel::Serializer
    attributes :id

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

    def value
      object.option.value
    end

    def upper
      object.option.upper
    end

    def lower
      object.option.lower
    end

    def sequence
      object.option.sequence
    end

    def after_attempt
      object.option.after_attempt
    end

  end
end