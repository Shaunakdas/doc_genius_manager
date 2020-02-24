module Api::V1::PracticeQuestions
  class InversionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :entry_sequence, :entry_delay, :question, :questions,  :pairs, :content_report

    def question
      linked_game_questions[0].question.display
    end
    
    def questions
      ActiveModel::ArraySerializer.new(linked_game_questions, each_serializer: InversionBlockSerializer)
    end

    def pairs
      list = []
      linked_game_questions.first.sub_questions.each do |q|
        list << InversionQuestionSerializer.new(q).as_json[:inversion_question]
      end
      powerup = ["shrink", "arrow", "blast", "snow"].sample
      powerup_index = rand(0..(list.count-1))
      list[powerup_index][:powerup] = powerup if list.length > 3 && powerup_index
      return list
    end

    def pair_count
      linked_game_questions.length
    end

    def content_report
      ActiveModel::ArraySerializer.new(linked_game_questions.first.sub_questions, each_serializer: InversionContentSerializer)
    end

  end
end