module Api::V1::PracticeQuestions
  class PracticeOptionSerializer < ActiveModel::Serializer
    attributes :id

    def type
      object.option.value_type
    end

    def display
      object.option.display
    end

    def value
      object.option.value
    end

  end
end