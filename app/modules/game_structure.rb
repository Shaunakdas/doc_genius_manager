module GameStructure
  extend self

  # Get Allowed Keys in parent question
  def parent_question_fields game
    parent_question_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if parent_question_structure(game)
  end
  def question_fields game
    question_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if question_structure(game)
  end

  def option_fields game
    option_structure(game).keys.select{ |item| !item.to_s.start_with?('_') } if option_structure(game)
  end

  # Get structure of different acad entity
  def option_structure game
    parent_question_structure(game)[:options].first if parent_question_structure(game) && parent_question_structure(game)[:options]
  end

  def question_structure game
    parent_question_structure(game)[:blocks].first if parent_question_structure(game) && parent_question_structure(game)[:blocks]
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
      options: [
        {
          entity_type: "game_question",
          answer: "string",
          correct: "bool",
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
      options: [
        {
            entity_type: "game_option",
            upper: "string",
            lower: "string",
            sequence: "string",
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
      _required_fields: "question,hint_content,solution,answer"
    }
  end

  def discounting_structure
    {
      entity_type: "game_question",
      question: "string",
      solution: "string",
      options: [
        {
            entity_type: "game_option",
            upper: "string",
            lower: "string",
            attempted: "string",
            sequence: "sequence",
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
      mode: "string",
      question: "string",
      answer: "string",
      hint_content: "string",
      options: [
          {
              entity_type: "game_option",
              type: "string",
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
      option_refs: [
        {
            entity_type: "game_option",
            display: "string",
            powerup: "bool",
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
      numpad: "csv",
      _required_fields: "question,answer"
    }
  end

  def proportion_structure
    {
      
      entity_type: "game_question",
      blocks: [
        {
            title: "string",
            type: "dropdown",
            _type: "sector,math,text",
            _required_fields: "type",
            faces: [
              {
                  display: "string",
                  solution: "string",
                  title: "string",
                  value_type: "string",
                  key: "sequence",
                  value: "string",
                  option_index: "sequence",
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
      _mode: "army,fruit,education,distance,counting,age,food,time,money,petrol",
      title: "string",
      _required_fields: "question,mode,title",
      options: [
          {
              entity_type: "game_option",
              answer: "string",
              correct: "bool",
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
      blocks: [
        {
          entity_type: "game_question",
          question: "string",
          section_question: "string",
          time: "positive_integer",
          solution: "string",
          _required_fields: "question,section_question,time",
          options: [
            {
                entity_type: "game_option",
                answer: "string",
                correct: "bool",
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
      sections: [
        {
          entity_type: "game_question",
          bubble: "string",
          question: "string",
          tip: "string",
          hint_content: "string",
          correct_option_count: "positive_integer",
          _required_fields: "bubble,question,correct_option_count",
          options: [
            {
                entity_type: "game_option",
                answer: "string",
                correct: "bool",
                _required_fields: "answer,correct"
            }
          ]
        }
      ]
    }
  end

end