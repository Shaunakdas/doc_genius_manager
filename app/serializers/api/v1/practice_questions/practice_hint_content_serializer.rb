module Api::V1::PracticeQuestions
  class PracticeHintContentSerializer < ActiveModel::Serializer
    attributes :text, :section, :entity_type

    def entity_type
      "hint_content"
    end

    def text
      object.display
    end

    def section
      object.position
    end
  end
end