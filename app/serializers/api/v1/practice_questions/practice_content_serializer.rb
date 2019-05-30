module Api::V1::PracticeQuestions
  class PracticeContentSerializer < ActiveModel::Serializer
    attributes :id, :title, :sub_title

    def title
      object.question.display
    end

    def sub_title
      if object.correct_game_options.count > 0
        object.correct_game_options.first.option.display || object.correct_game_options.first.option.correct.to_s
      else
        return false.to_s
      end
    end
  end
end