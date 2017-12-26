module Api::V1
  class ApiErrorSerializer < ActiveModel::Serializer
    attributes :id,:error
  end
end
