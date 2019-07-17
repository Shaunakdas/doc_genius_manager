module Api::V1::PracticeQuestions
  class DragonboxGameSerializer < PracticeGameSerializer
    attributes :title, :lives, :correct_count, :questions

    def questions
      ActiveModel::ArraySerializer.new(object.game_questions, each_serializer: DragonboxQuestionSerializer)
    end
  end
end