module Api::V1
  class ChapterTopicSerializer < AcadEntitySerializer
    attribute :topic_list
    def topic_list
      ActiveModel::ArraySerializer.new(object.practice_topics, each_serializer: TopicImageSerializer)
    end
  end
end
