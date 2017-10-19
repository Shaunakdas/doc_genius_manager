module Api::V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :email
  end
end
