module GameStructure
  extend self

  def generic_question_fields game_holder, is_parent
    return GameStructure.parent_question_fields(game_holder.game.slug).map &:to_s if is_parent
    return GameStructure.question_fields(game_holder.game.slug).map &:to_s
  end

  def generic_question_required_fields game_holder, is_parent
    return GameStructure.parent_question_structure(game_holder.game.slug)[:_required_fields].split(",") if is_parent
    return GameStructure.question_structure(game_holder.game.slug)[:_required_fields].split(",")
  end

  def option_required_fields game_slug
    return GameStructure.option_structure(game_slug)[:_required_fields].split(",") if GameStructure.option_structure(game_slug)
    return []
  end

  # Get Allowed Keys in parent question
  def parent_question_fields game
    return parent_question_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if parent_question_structure(game)
  end
  def question_fields game
    return question_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if question_structure(game)
  end

  def option_fields game
    return option_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if option_structure(game)
  end

  # Get structure of different acad entity
  def option_structure game
    return parent_question_structure(game)[:options].first if parent_question_structure(game) && parent_question_structure(game)[:options]
    return parent_question_structure(game)[:blocks].first[:options].first if parent_question_structure(game)[:blocks].first && parent_question_structure(game)[:blocks].first[:options]
  end

  def question_structure game
    return parent_question_structure(game)[:blocks].first if parent_question_structure(game) && parent_question_structure(game)[:blocks]
  end

  def parent_question_structure game
    case game
    when "agility"
      agility_structure
    when "conversion"
      conversion_structure
    when "diction"
      diction_structure
    when "discounting"
      discounting_structure
    when "division"
      division_structure
    when "estimation"
      estimation_structure
    when "inversion"
      inversion_structure
    when "percentages"
      percentages_structure
    when "proportion"
      proportion_structure
    when "purchasing"
      purchasing_structure
    when "refinement"
      refinement_structure
    when "tipping"
      tipping_structure
    else
      agility_structure
    end
  end

  def agility_structure
    {
      entity_type: "game_question",
      question: "string",
      solution: "string",
      _is_parent_question: false,
      options: [
        {
          entity_type: "game_option",
          answer: "string",
          correct: "bool",
          _correct: "bool",
          _required_fields: "answer,correct"
        }
      ],
      _option_count: 4,
      _required_fields: "question"
    }
  end

  def conversion_structure
    {
      entity_type: "game_question",
      question: "string",
      _is_parent_question: false,
      options: [
        {
            entity_type: "game_option",
            upper: "string",
            lower: "string",
            sequence: "sequence",
            _sequence: "sequence,1,2,3,4,5,6",
            _required_fields: "upper,sequence"
        }
      ],
      _option_count: 4,
      _required_fields: "question"
    }
  end

  def diction_structure
    {
      entity_type: "game_question",
      question: "string",
      hint_content: "string",
      solution: "string",
      answer: "bool",
      _answer: "bool",
      _is_parent_question: false,
      _required_fields: "question,hint_content,solution,answer"
    }
  end

  def discounting_structure
    {
      entity_type: "game_question",
      question: "string",
      solution: "string",
      _is_parent_question: false,
      options: [
        {
            entity_type: "game_option",
            upper: "string",
            lower: "string",
            attempted: "string",
            sequence: "sequence",
            _sequence: "sequence,1,2,3,4,5,6",
            _required_fields: "upper,attempted,sequence"
        }
      ],
      _option_count: 4,
      _required_fields: "question"
    }
  end

  def division_structure
    {
      entity_type: "game_question",
      mode: "dropdown",
      _mode: "dropdown,addition_roman_left,addition_roman_right,multiplication_long,multiple_addition,addition_algebra,multiplication_factor_exponent",
      question: "string",
      answer: "string",
      hint_content: "string",
      _is_parent_question: false,
      options: [
          {
              entity_type: "game_option",
              type: "dropdown",
              _type: "dropdown,int,math",
              display: "string",
              value: "string",
              _required_fields: "type,display,value"
          }
        ],
        _option_count: 4,
        _required_fields: "mode,question,answer"
      }
  end

  def inversion_structure
    {
      entity_type: "game_question",
      solution: "string",
      _is_parent_question: false,
      option_refs: [
        {
            entity_type: "game_option",
            display: "string",
            _required_fields: "string"
        }
      ],
      _required_fields: "solution"
    }
  end

  def percentages_structure
    {
      entity_type: "game_question",
      question: "string",
      tips: "string",
      hint_content: "string",
      answer: "string",
      _is_parent_question: false,
      _required_fields: "question,answer"
    }
  end

  def proportion_structure
    {
      
      entity_type: "game_question",
      _is_parent_question: true,
      blocks: [
        {
            title: "string",
            type: "dropdown",
            _is_parent_question: false,
            _type: "dropdown,sector,math,text",
            _required_fields: "type",
            faces: [
              {
                  display: "string",
                  solution: "string",
                  title: "string",
                  value_type: "string",
                  key: "sequence",
                  _key: "sequence,1,2,3,4,5,6",
                  value: "string",
                  option_index: "sequence",
                  _option_index: "sequence,1,2,3,4,5,6",
                  _required_fields: "display,solution,title,value_type,key,value,option_index",
              }
            ]
          }
        ]
      }
  end

  def purchasing_structure
    {
      entity_type: "game_question",
      question: "string",
      hint_content: "string",
      mode: "dropdown",
      _mode: "dropdown,army,fruit,education,distance,counting,age,food,time,money,petrol",
      title: "string",
      _required_fields: "question,mode,title",
      _is_parent_question: false,
      options: [
          {
              entity_type: "game_option",
              answer: "string",
              correct: "bool",
              _correct: "bool",
              _required_fields: "answer,correct",
          }
        ]
      }
  end

  def refinement_structure
    {
      entity_type: "game_question",
      question: "string",
      _required_fields: "question",
      _is_parent_question: true,
      blocks: [
        {
          entity_type: "game_question",
          question: "string",
          section_question: "string",
          time: "positive_integer",
          _time: "positive_integer",
          solution: "string",
          _is_parent_question: false,
          _required_fields: "question,section_question,time",
          options: [
            {
                entity_type: "game_option",
                answer: "string",
                correct: "bool",
                _correct: "bool",
                _required_fields: "answer,correct",
            }
          ]
        }
      ]
    }
  end

  def tipping_structure
    {
      entity_type: "game_question",
      _is_parent_question: true,
      sections: [
        {
          entity_type: "game_question",
          bubble: "string",
          question: "string",
          tip: "string",
          hint_content: "string",
          correct_option_count: "positive_integer",
          _is_parent_question: false,
          _correct_option_count: "positive_integer",
          _required_fields: "bubble,question,correct_option_count",
          options: [
            {
                entity_type: "game_option",
                answer: "string",
                correct: "bool",
                _correct: "bool",
                _required_fields: "answer,correct"
            }
          ]
        }
      ]
    }
  end

end