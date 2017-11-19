class AcadEntityScore < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
  belongs_to :session_score
  belongs_to :user
  
  def completed_count
    passed_count + failed_count
  end

  def self.update_aggregates(session_score)
    puts session_score
    puts session_score.game_session.game_holder.question_type
    puts session_score.game_session.user
  end
end
