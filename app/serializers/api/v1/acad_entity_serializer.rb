class Api::V1::AcadEntitySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
end
