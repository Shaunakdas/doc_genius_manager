class Api::V1::StandardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sequence
end
