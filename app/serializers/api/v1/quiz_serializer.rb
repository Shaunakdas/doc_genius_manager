module Api::V1
  class QuizSerializer < AcadEntitySerializer
    attributes :id, :title, :name, :slug, :image_url, :enabled

  end
end
