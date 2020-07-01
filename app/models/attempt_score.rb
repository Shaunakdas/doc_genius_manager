class AttemptScore < ApplicationRecord
  belongs_to :attempt_item, polymorphic: true

  def total_value
    normal_marks.to_i + (speedy_marks || 0) + (complete_set_marks || 0) + (actual_answer_marks || 0) + (consistency_marks || 0) + (remaining_time_marks || 0) + (remaining_lives_marks || 0)
  end

  def create_standings
    if attempt_item_type == "GameSession"
      if star_count.to_i > 1
        level = attempt_item.game_level
        if level
          topic = level.game_holder.acad_entity
          user = attempt_item.user
          topic.set_attempt_standing(user)

          next_level = level.next_topic_level
          if !next_level.nil?
            next_level.set_attempt_standing(user)
            topic.set_level_standing(next_level, user)
          else
            next_topic = topic.next_chapter_topic
            if !next_topic.nil?
              next_topic.set_fresh_standing(user)
            end
          end
        end
        
      end
    end
  end
end
