module Api::V1::PracticeQuestions
  class PracticeContentSerializer < ActiveModel::Serializer
    attributes :id, :title, :sub_title

    def title
      object.question.display
    end

    def sub_title
      object.correct_game_options.first.option.display if object.correct_game_options.count > 0
    end
  end
end