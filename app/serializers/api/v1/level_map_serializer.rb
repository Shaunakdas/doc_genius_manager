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
      suggested_games = Rails.cache.fetch("suggested_games_cache", expires_in: 10.hours) do
        ActiveModel::ArraySerializer.new(object.practice_game_holders, each_serializer: GameHolderSerializer)
      end
      return suggested_games
    end

    def chapters
      chapters = Rails.cache.fetch("chapter_cache", expires_in: 2.hours) do
        ActiveModel::ArraySerializer.new(object.enabled_chapters, each_serializer: ChapterLevelSerializer).as_json
      end
      list = star_list.to_h
      chapters.each do |chapter|
        chapter[:activities] = chapter[:activities].as_json
        chapter[:activities].each do |activity|
          activity["star_count"] = list[activity["id"]] if !list[activity["id"]].nil?
          activity[:star_count] = list[activity[:id]] if !list[activity[:id]].nil?
        end
      end
      return chapters
    end

    def star_list
      return nil if object.game_sessions.length == 0
      attempt_list =  object.game_sessions.order(:created_at).reverse.uniq{|x| x.game_level_id}
      star_counts = {}
      attempt_list.each do |game_session|
        star_counts[game_session.game_level_id]=game_session.attempt_score.star_count if !game_session.attempt_score.nil?
      end
      return star_counts
    end
  end
end