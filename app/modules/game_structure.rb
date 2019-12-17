module GameStructure
  extend self
  def agility_structure
    {
      entity_type: "game_question",
      question: "string",
      hint: "string",
      options: [
        {
          entity_type: "game_question",
          answer: "string",
          correct: "bool"
        }
      ],
      "_option_count": 4
    }
  end

  def conversion_structure
    {
      entity_type: "game_question",
      mode: "string",
      _mode: "string",
      question: "string",
      answer: "string",
      hint: "string",
      options: [
        {
            entity_type: "game_option",
            type: "string",
            _type: "string",
            display: "string",
            value: "string"
        }
      ],
      "_option_count": 4,
    }
  end

  def diction_structure
    {
      entity_type: "game_question",
      question: "string",
      hint: "string",
      solution: "string",
      answer: "bool"
    }
  end

  def discounting_structure
    {
      entity_type: "game_question",
      question: "string",
      hint: "string",
      options: [
        {
            entity_type: "game_option",
            upper: "string",
            lower: "",
            attempted: "string",
            sequence: "sequence"
        }
      ],
      "_option_count": 4,
    }
  end

  def division_structure
    {
      entity_type: "game_question",
      mode: "string",
      _mode: "string",
      question: "string",
      answer: "string",
      hint: "string",
      options: [
          {
              entity_type: "game_option",
              type: "string",
              _type: "string",
              display: "string",
              value: "string"
          }
        ],
        "_option_count": 4,
      }
  end

  def inversion_structure
    {
      entity_type: "game_question",
      hint: "string",
      option_refs: [
          {
              entity_type: "game_option",
              display: "string"
          }
        ]
      }
  end

  def percentages_structure
    {
      entity_type: "game_question",
      question: "string",
      tips: "string",
      hint: "string",
      answer: "string",
      numpad: "csv"
    }
  end

  def proportion_structure
    {
      
      entity_type: "game_question",
      blocks: [
        {
            title: "string",
            type: "string",
            _type: "string",
            faces: [
              {
                  display: "string",
                  hint: "string",
                  title: "string",
                  value_type: "string",
                  key: "sequence",
                  value: "string",
                  option_index: "sequence"
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
      hint: "string",
      mode: "dropdown",
      _mode: "army,fruit,education,distance,counting,age,food,time,money,petrol",
      title: "string",
      options: [
          {
              entity_type: "game_option",
              answer: "string",
              correct: "bool"
          }
        ]
      }
  end

  def refinement_structure
    {
      entity_type: "game_question",
      question: "string",
      blocks: [
        {
          entity_type: "game_question",
          question: "string",
          section_question: "string",
          time: "positive_integer",
          hint: "string",
          options: [
            {
                entity_type: "game_option",
                answer: "string",
                correct: "bool"
            }
          ]
        }
      ]
    }
  end

  def tipping_structure
    {
      entity_type: "game_question",
      question: "string",
      blocks: [
          {
              entity_type: "game_question",
              question: "string",
              section_question: "string",
              time: "positive_integer",
              hint: "string",
              options: [
                  {
                      entity_type: "game_option",
                      answer: "string",
                      correct: "bool"
                  }
                ]
              }
            ]
          }
  end

end