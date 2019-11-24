module Api::V1::PracticeQuestions
  class PracticeHintSerializer < ActiveModel::Serializer
    attributes :type, :content, :entity_type

    def entity_type
      "hint"
    end

    def type
      object.value_type
    end

    def content
      ActiveModel::ArraySerializer.new(object.hint_contents, each_serializer: PracticeHintContentSerializer)
    end
  end
end