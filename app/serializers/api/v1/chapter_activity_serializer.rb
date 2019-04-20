module Api::V1
  class ChapterActivitySerializer < ActiveModel::Serializer
    attributes :sequence_standard, :name, :slug, :activities
    def activities
      ActiveModel::ArraySerializer.new(object.practice_game_holders, each_serializer: GameHolderSerializer)
    end
  end
end
