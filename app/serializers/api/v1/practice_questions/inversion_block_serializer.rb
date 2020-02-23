module Api::V1::PracticeQuestions
  class InversionBlockSerializer < PracticeQuestionSerializer
    attributes :display,  :pairs, :content_report

    def display
      object.question.display
    end

    def pairs
      list = []
      object.sub_questions.each do |q|
        list << InversionQuestionSerializer.new(q).as_json[:inversion_question]
      end
      powerup = ["shrink", "arrow", "blast", "snow"].sample
      powerup_index = rand(0..(list.count-1))
      list[powerup_index][:powerup] = powerup if list.length > 3 && powerup_index
      return list
    end

    def pair_count
      object.sub_questions.length
    end

    def content_report
      ActiveModel::ArraySerializer.new(object.sub_questions, each_serializer: InversionContentSerializer)
    end

  end
end