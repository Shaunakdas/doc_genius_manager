module Api::V1::PracticeQuestions
  class DragonboxQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :mode, :steps, :sections
    

    def sections
      # ActiveModel::ArraySerializer.new(object.sub_questions, each_serializer: DragonboxSectionSerializer)
      {
        left: op_items(:left),
        right: op_items(:right),
        bottom: op_items(:bottom)
      }
    end

    def game_section position
      object.sub_questions.each do |game_ques|
        pp position
        pp game_ques.question.position
        puts game_ques.question.position == position
        return game_ques if game_ques.question.position.to_s == position.to_s
      end
      return nil
    end

    def op_items position
      section  = game_section(position)
      return {
        items: section.nil? ? nil : section.game_options.map{ |r| r.option.reference_id}
      }
    end
  end
end