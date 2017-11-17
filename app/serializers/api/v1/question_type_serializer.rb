module Api::V1
  class QuestionTypeSerializer < AcadEntitySerializer
    # attributes :id, :name, :slug, :sequence
    attributes :sub_topic, :sequence
    has_one :sub_topic, serializer: SubTopicSerializer
  end
end