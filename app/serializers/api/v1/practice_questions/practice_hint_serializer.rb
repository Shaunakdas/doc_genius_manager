module Api::V1::PracticeQuestions
  class PracticeHintSerializer < ActiveModel::Serializer
    attributes :type, :content

    def type
      object.value_type
    end

    def content
      ActiveModel::ArraySerializer.new(object.hint_contents, each_serializer: PracticeHintContentSerializer)
    end
  end
end