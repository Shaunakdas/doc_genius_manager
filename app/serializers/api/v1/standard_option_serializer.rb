module Api::V1
  class StandardOptionSerializer < StandardSerializer
    attributes :key, :label

    def label
      object.name+'th Class'
    end

    def key
      object.slug
    end

  end
end
