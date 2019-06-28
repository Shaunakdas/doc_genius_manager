class GameOptionAttempt < ApplicationRecord
  belongs_to :game_option
  belongs_to :game_question_attempt
  has_one :attempt_score, as: :attempt_item, dependent: :destroy

  def set_attempt_score option_obj
    attempt_data = option_obj[:option_attempt_data] if option_obj[:option_attempt_data]
    attempt_data = option_obj[:item_attempt_data] if option_obj[:item_attempt_data]
    attempt_data = option_obj[:section_attempt_data] if option_obj[:section_attempt_data]
    create_attempt_score!(get_attempt_fields(attempt_data)) if attempt_data
  end

  def get_attempt_fields attempt_obj
    output_json = attempt_obj.except(:marks)
    attempt_obj[:marks].each do |k,v|
      output_json["#{k}_marks".to_sym] = v
    end
    return output_json.as_json.map { |k, v| [k.to_sym, v] }.to_h
  end
end
