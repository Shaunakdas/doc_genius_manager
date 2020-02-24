module Api::V1
  class VictoryCardSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug, :title, :description, :max_count, :sequence
  end
end
