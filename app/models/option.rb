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
      hint: "hint",
      title: "title"
    }
  end
end
