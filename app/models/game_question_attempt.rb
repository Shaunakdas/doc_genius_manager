class GameQuestionAttempt < ApplicationRecord
  belongs_to :game_question
  belongs_to :game_session
  has_one :attempt_score, as: :attempt_item, dependent: :destroy


  def set_attempt_score question_obj
    section_data = question_obj[:section_attempt_data]
    create_attempt_score!(get_attempt_fields(section_data))
    if section_data[:attempted_option]
      game_option = GameOption.find(section_data[:attempted_option])
      game_option.create_attempt_data(nil, self)
    end
    if question_obj[:items]
      question_obj[:items].each do |item_obj|
        game_option = GameOption.find(item_obj[:id])
        game_option.create_attempt_data(item_obj, self)
      end
    end
  end

  def get_attempt_fields attempt_obj
    output_json = attempt_obj.except(:marks, :attempted_option)
    attempt_obj[:marks].each do |k,v|
      output_json["#{k}_marks".to_sym] = v
    end
    return output_json.as_json.map { |k, v| [k.to_sym, v] }.to_h
  end
end
