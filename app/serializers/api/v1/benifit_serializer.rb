module Api::V1
  class BenifitSerializer < ActiveModel::Serializer
    attributes :id, :slug, :name, :sequence, :explainer, :image_url

  end
end
