module Api::V1::PracticeQuestions
  class DragonboxQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :mode, :steps, :sections, :setup
    has_many :hints, serializer: PracticeHintSerializer

    def sections
      {
        left: op_items(:left),
        right: op_items(:right),
        bottom: op_items(:bottom)
      }
    end

    def game_section position
      object.sub_questions.each do |game_ques|
        return game_ques if game_ques.question.position.to_s == position.to_s
      end
      return nil
    end

    def items section, position
      fraction_op_type = OptionType.where(slug: "fraction").first
      if section && fraction_op_type
        return section.game_options.where(option_type: [nil]).map{ |r| r.option.reference_id}
      end
      return nil
    end

    def fraction_items section, position
      fraction_op_type = OptionType.where(slug: "fraction").first
      if section && fraction_op_type
        fraction_ops = section.game_options.where(option_type: fraction_op_type)
        fraction_items = []
        fraction_ops.last(1).each do |op|
          fraction_items << { 
            upper: op.sub_options.where(position: :numerator).map{ |r| r.option.reference_id},
            lower: op.sub_options.where(position: :denominator).map{ |r| r.option.reference_id}
          }
        end
        return fraction_items if fraction_items.length > 0
      end
      return nil
    end

    def op_items position
      section  = game_section(position)
      items_obj = items(section, position)
      fraction_items_obj = fraction_items(section, position)
      op_items_obj = {}
      op_items_obj[:items] = items_obj if (items_obj &&  items_obj.length > 0)
      op_items_obj[:fractions] = fraction_items_obj if (fraction_items_obj &&  fraction_items_obj.length > 0)
      return op_items_obj
    end
  end
end