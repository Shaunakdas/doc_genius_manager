module Api::V1
  class LevelMapSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :sex, :birth, :standard, :suggested_games, :chapters, :star_list
    
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

    def star_list
      return nil if object.game_sessions.length == 0
      attempt_list =  object.game_sessions.order(:created_at).uniq{|x| x.game_level_id}
      star_counts = {}
      attempt_list.each do |game_session|
        star_counts[game_session.game_level_id]=game_session.attempt_score.star_count if !game_session.attempt_score.nil?
      end
      return star_counts
    end
    # has_many :recent_questions, serializer: QuestionTypeSerializer
  end
end