class AcadEntityScore < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
  belongs_to :session_score
  belongs_to :user
  
  def completed_count
    passed_count + failed_count
  end

  def self.update_aggregates(session_score)
    puts session_score.to_json
    question_type =  session_score.game_session.game_holder.question_type
    user =  session_score.game_session.user
    session_score.game_session.game_holder.acad_entities.each do |acad_entity|
      score = self.where(acad_entity: acad_entity, user: user).first
      if score
        self.update(session_score, acad_entity)
      else
        self.create(session_score, acad_entity)
      end
    end
  end

  def self.create(session_score, acad_entity)
    score = self.new( session_score: session_score, acad_entity: acad_entity,
      user: session_score.game_session.user,
      average: session_score.value, maximum: session_score.value, last: session_score.value,
      time_spent: session_score.time_taken)
    score.passed_count = (session_score.passed==true)?1:0
    score.failed_count = (session_score.failed==true)?1:0
    score.seen_count = (session_score.seen==true)?1:0
    score.save!
    # puts score.to_json
  end

  def self.update(session_score, acad_entity)
    score = self.where( acad_entity: acad_entity, user: session_score.game_session.user).first
    score.session_score = session_score
    score.average = ((score.average*score.completed_count) + session_score.value)/( score.completed_count+1 )
    score.maximum = [score.maximum, session_score.value].max
    score.passed_count += 1 if session_score.passed
    score.failed_count += 1 if session_score.failed
    score.seen_count += 1 if session_score.seen
    score.last = session_score.value
    score.save!
    # puts score.to_json
  end
end
