module Api::V1
  class TopicwiseSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :sex, :birth,
      :level_locked, :standard, :suggested_games, :level_list, :jump
    
    def sex
      object.sex.to_s.humanize if object.sex.present? 
    end
    
    def standard
      StandardSerializer.new(object.standard, scope: scope, root: false)
    end

    def suggested_games
      suggested_games = Rails.cache.fetch("suggested_games_cache", expires_in: 10.hours) do
        ActiveModel::ArraySerializer.new([object.practice_game_holders.first], each_serializer: GameHolderSerializer)
      end
      return suggested_games
    end

    def current_level_id
      return nil if object.level_standing.nil?
      return object.level_standing.acad_entity.id
    end

    def level_list
      topic = Topic.find(scope[:topic_id])
      return nil if topic.nil?
      levels = Rails.cache.fetch("topic_#{topic.id}_cache", expires_in: 2.hours) do
        ActiveModel::ArraySerializer.new(topic.practice_game_levels, each_serializer: GameLevelSerializer).as_json
      end
      list = star_list.to_h
      levels.each do |activity|
        activity["star_count"] = list[activity["id"]] if !list[activity["id"]].nil?
        activity[:star_count] = list[activity[:id]] if !list[activity[:id]].nil?
        activity[:current] = current_activity(current_level_id,activity[:id])
        activity[:locked] = locked_status(activity[:star_count],activity[:current] )
      end
      return levels
    end

    def locked_status star,current
      return false if !object.role.nil? && object.role.slug == "Admin"
      return true if (star.nil? && current.nil?)
      return false
    end

    def current_activity current_level_id, iterator_id
      return nil if current_level_id.nil?
      if current_level_id == iterator_id
        return {
          jump: scope[:jump],
          standing: true
        }
      end
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

    def level_locked
      false
    end

    def jump
      return scope[:jump]
    end
  end
end