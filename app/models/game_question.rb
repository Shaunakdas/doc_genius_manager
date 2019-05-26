class GameQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :game_holder, optional: true
  has_many :sub_questions, -> { order 'id asc' }, class_name: "GameQuestion", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "GameQuestion", optional: true
  has_many :game_options, -> { order 'id asc' }
  has_many :game_question_attempts

  def proportion_blocks
    game_options_list = []
    sub_question_id_list = sub_questions.map{|x|x.id}
    sub_questions.each do |s_q|
      option_i = 0
      s_q.game_options.each do |g_o|
        option_i = option_i +1
        game_options_list  << g_o.option.slice(:id, :display, :hint, :title, :value_type)
        game_options_list.last[:key] = sub_question_id_list.index(g_o.game_question.id)+1
        game_options_list.last[:value] = g_o.option.display
        game_options_list.last[:option_index] = option_i
      end
    end
    gr_list = game_options_list.group_by { |d| d[:option_index] }
    new_list = []
    gr_list.each do |key,value|
      new_list << { title: value[0][:title], type: value[0][:value_type], faces: value}
    end
    return new_list
  end

  def correct_game_options
    game_options.reject { |g_o| !g_o.option.correct }
  end

  def incorrect_game_options
    game_options.reject { |g_o| g_o.option.correct }
  end

  def create_attempt_data question_obj, game_session
    ques_attempt = game_question_attempts.create!(time_attempt: Time.now, game_session: game_session)
    ques_attempt.set_attempt_score(question_obj)
  end
end
