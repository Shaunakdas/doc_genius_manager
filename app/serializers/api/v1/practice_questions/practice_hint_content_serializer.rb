module Api::V1::PracticeQuestions
  class PracticeHintContentSerializer < ActiveModel::Serializer
    attributes :text, :section

    def text
      object.display
    end

    def section
      object.position
    end
  end
end