module Api::V1
  class TopicSerializer < AcadEntitySerializer
    attributes :chapter, :sequence
    has_one :chapter, serializer: ChapterSerializer
  end
end
