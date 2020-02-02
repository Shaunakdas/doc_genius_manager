module Api::V1
  class ChapterLevelSerializer < ActiveModel::Serializer
    attributes :sequence_standard, :name, :slug, :activities
    def activities
      ActiveModel::ArraySerializer.new(object.practice_game_levels, each_serializer: GameLevelSerializer)
    end
  end
end
