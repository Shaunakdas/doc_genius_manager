class GameQuestionAttempt < ApplicationRecord
  belongs_to :game_question
  belongs_to :game_session
  has_one :attempt_score, as: :attempt_item, dependent: :destroy


  def set_attempt_score question_obj
    section_data = question_obj[:section_attempt_data]
    create_attempt_score!(get_attempt_fields(section_data))
    if section_data[:attempted_option] && section_data[:attempted_option] > 0
      game_option = GameOption.find(section_data[:attempted_option])
      game_option.create_attempt_data(nil, self)
    end
    item_list = question_obj[:items] if question_obj[:items]
    item_list = question_obj[:options] if question_obj[:options]
    item_list = question_obj[:faces] if question_obj[:faces]
    if item_list
      item_list.each do |item_obj|
        game_option = GameOption.find(item_obj[:id])
        game_option.create_attempt_data(item_obj, self) if game_option
      end
    end
  end

  def get_attempt_fields attempt_obj
    output_json = attempt_obj.except(:marks, :attempted_option)
    if attempt_obj[:marks]
      attempt_obj[:marks].each do |k,v|
        output_json["#{k}_marks".to_sym] = v
      end
    end
    return output_json.as_json.map { |k, v| [k.to_sym, v] }.to_h
  end
end
