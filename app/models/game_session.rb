class GameSession < ApplicationRecord
  belongs_to :game_holder
  belongs_to :user
  validates_presence_of :start
  has_one :session_score
  has_one :attempt_score, as: :attempt_item, dependent: :destroy

  def self.list(list_params)
    if list_params["game_holder_id"]
      query = list_params["game_holder_id"]
      game_session_list = GameSession.where(game_holder_id: query).order('created_at DESC')
    elsif list_params["user_id"]
      query = list_params["user_id"]
      game_session_list = GameSession.where(user_id: query).order('created_at DESC')
    elsif list_params["start"] && !list_params["finish"]
      # '03/05/2010'
      start = DateTime.strptime(list_params["start"], '%d/%m/%Y')
      query = list_params["start"]
      game_session_list = GameSession.where("start > ?", start).order('created_at DESC') if !list_params["finish"]
      if list_params["finish"]
        finish = DateTime.strptime(list_params["finish"], '%d/%m/%Y')
        game_session_list = GameSession.where("start > ?", start).where("finish < ?", finish).order('created_at DESC')
      end
    elsif list_params["question_type_id"]
      query = list_params["question_type_id"]
      game_session_list =[]
      GameHolder.where( question_type_id: query).order('created_at DESC').all do |game|
        game_session_list.concat GameSession.where( game_holder: game).order('created_at DESC')
      end
    else
      game_session_list = GameSession.all
    end
    total_count = game_session_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    game_session_list = game_session_list.drop(page_num * limit).first(limit)
    list_response = {result: game_session_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end

  def recent_scores
    # game_holder.question_type.attempt_scores
  end

  def score_rank
    sorted = recent_scores.sort_by{ |score| score.value }.reverse
    sorted.find_index(session_score)
  end

  def parse_result result_json
    create_attempt_score!(get_attempt_fields(result_json[:game_attempt_data]))
    ques_list = result_json[:sections] if result_json[:sections]
    ques_list = result_json[:pairs] if result_json[:pairs]
    ques_list.each do |question_json|
      game_question = GameQuestion.find(question_json[:id])
      game_question.create_attempt_data(question_json, self)
    end
  end

  def upload_agility_result result_json
    
  end

  def get_attempt_fields attempt_obj
    output_json = attempt_obj.except(:marks)
    attempt_obj[:marks].each do |k,v|
      output_json["#{k}_marks".to_sym] = v
    end
    return output_json.as_json.map { |k, v| [k.to_sym, v] }.to_h
  end
end
