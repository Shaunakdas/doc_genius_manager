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

  end
end