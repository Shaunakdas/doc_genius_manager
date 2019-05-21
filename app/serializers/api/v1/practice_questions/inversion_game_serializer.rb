module Api::V1::PracticeQuestions
  class InversionGameSerializer < PracticeGameSerializer
    attributes :title, :time, :entry_sequence, :entry_delay, :question,  :pairs

    def question
      object.game_questions[0].question.display
    end

    def pairs
      list = []
      object.game_questions.first.sub_questions.each do |q|
        list << InversionQuestionSerializer.new(q).as_json[:inversion_question]
      end
      powerup = ["shrink", "arrow", "blast", "snow"].sample
      powerup_index = rand(3..list.length)
      list[powerup_index][:powerup] = powerup
      return list
    end

    def pair_count
      object.game_questions.length
    end

  end
end