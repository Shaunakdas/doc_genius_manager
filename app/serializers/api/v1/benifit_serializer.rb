module Api::V1
  class BenifitSerializer < ActiveModel::Serializer
    attributes :id, :slug, :title, :sequence, :explainer, :image_url

  end
end
