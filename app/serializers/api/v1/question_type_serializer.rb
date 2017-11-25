module Api::V1
  class QuestionTypeSerializer < AcadEntitySerializer
    # attributes :id, :name, :slug, :sequence
    attributes :sub_topic, :sequence, :image_url, :title, :subTitle
    has_one :sub_topic, serializer: SubTopicSerializer

    def title
      object.name
    end

    def subTitle
      object.sub_topic.topic.chapter.name
    end
  end
end