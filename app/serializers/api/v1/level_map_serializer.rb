module Api::V1
  class LevelMapSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :sex, :birth, :standard, :suggested_games, :chapters
    
    def sex
      object.sex.to_s.humanize if object.sex.present? 
    end
    
    def standard
      StandardSerializer.new(object.standard, scope: scope, root: false)
    end

    def suggested_games
      ActiveModel::ArraySerializer.new(object.practice_game_holders, each_serializer: GameHolderSerializer)
    end

    def chapters
      ActiveModel::ArraySerializer.new(object.enabled_chapters, each_serializer: ChapterLevelSerializer)
    end
    # has_many :recent_questions, serializer: QuestionTypeSerializer
  end
end