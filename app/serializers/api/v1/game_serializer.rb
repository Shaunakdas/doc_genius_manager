module Api::V1
  class GameSerializer < AcadEntitySerializer
    attributes :id, :name, :slug, :sequence, :question_text
  end
end
