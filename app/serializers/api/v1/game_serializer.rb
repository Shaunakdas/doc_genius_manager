module Api::V1
  class GameSerializer < AcadEntitySerializer
    attributes :id, :name, :slug
  end
end
