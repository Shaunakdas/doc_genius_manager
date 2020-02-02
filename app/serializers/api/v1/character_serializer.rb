module Api::V1
  class CharacterSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end