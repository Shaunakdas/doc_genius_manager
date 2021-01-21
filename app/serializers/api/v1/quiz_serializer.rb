module Api::V1
  class QuizSerializer < AcadEntitySerializer
    attributes :id, :header, :name, :slug, :s3_image_url, :enabled, :theme
    def s3_image_url
      "http://drona-player.docgenius.in/"+object.image_url.to_s
    end

    def header
      object.title.titleize
    end

    def theme
      GameHolder.theme_list[rand(GameHolder.theme_list.count)] if object.class.name == "GameHolder"
    end
  end
end
