class GameQuestionAttempt < ApplicationRecord
  belongs_to :game_question
  belongs_to :game_session
  has_one :attempt_score, as: :attempt_item, dependent: :destroy


  def set_attempt_score question_obj
    create_attempt_score!(get_attempt_fields(question_obj[:section_attempt_data]))
    # question_obj[:sections].each do |option_json|
    #   game_option = GameOption.find(option_json[:id])
    #   game_option.create_attempt_data(option_json, self)
    # end
  end

  def get_attempt_fields attempt_obj
    output_json = attempt_obj.except(:marks, :attempted_option)
    attempt_obj[:marks].each do |k,v|
      output_json["#{k}_marks".to_sym] = v
    end
    return output_json.as_json.map { |k, v| [k.to_sym, v] }.to_h
  end
end
