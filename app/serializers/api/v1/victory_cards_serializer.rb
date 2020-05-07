module Api::V1
  class VictoryCardSerializer < ActiveModel::Serializer
    attribute :id, :name, :slug, :title, :description, :max_count, :sequence
  end
end