module Api::V1
  class SubTopicSerializer < AcadEntitySerializer
    attributes :topic, :sequence
    has_one :topic, serializer: TopicSerializer
  end
end
