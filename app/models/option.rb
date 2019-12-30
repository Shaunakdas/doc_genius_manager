class Option < ApplicationRecord
  has_one :game_option


  def self.attribute_mapping
    {
      type: "value_type",
      display: "display",
      answer: "display",
      correct: "correct",
      index: "display_index",
      tips: "tip",
      value: "value",
      upper: "upper",
      lower: "lower",
      sequence: "sequence",
      after_attempt: "after_attempt",
      attempted: "after_attempt",
      hint: "hint",
      title: "title"
    }
  end

  def self.create_content params, game_holder
    params = Option.create_validations(params, game_holder)
    option_params = {}
    Option.attribute_mapping.each do | game_option_key, option_key  |
      option_params[option_key] = params[game_option_key] if !params[game_option_key].nil?
    end
    option = Option.new(option_params)
    option.save!
    return option
  end

  def self.create_validations(params, game_holder)
    required_fields = GameStructure.option_required_fields(game_holder.game.slug)
    return params if required_fields.length == 0 
    if required_fields.all? {|k| ((params.has_key? k) && (!params[k].nil?) && (params[k] != ""))}
      return params.permit(GameStructure.option_fields(game_holder.game.slug))
    else
      missing_fields = []
      required_fields.each do |k|
        missing_fields << k if !((params.has_key? k) && (!params[k].nil?) && (params[k] != ""))
      end
      raise ArgumentError.new("Option couldn't be created due to missing parameters : #{missing_fields.join(', ')}")
    end
  end
end
