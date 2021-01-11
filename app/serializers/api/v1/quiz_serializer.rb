module Api::V1
  class QuizSerializer < AcadEntitySerializer
    attributes :id, :title, :name, :slug, :s3_image_url, :enabled
    def s3_image_url
      "http://drona-player.docgenius.in/"+object.image_url.to_s
    end
  end
end
