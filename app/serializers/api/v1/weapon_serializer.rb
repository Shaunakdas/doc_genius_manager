module Api::V1
  class WeaponSerializer < ActiveModel::Serializer
    attributes :id, :name 
  end
end
