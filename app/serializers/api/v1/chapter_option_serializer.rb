module Api::V1
  class ChapterOptionSerializer < ChapterSerializer
    attributes :key

    def key
      object.slug
    end

  end
end
