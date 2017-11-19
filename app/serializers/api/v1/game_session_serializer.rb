module Api::V1
  class GameSessionSerializer < ActiveModel::Serializer
    attributes :id,:start, :finish
    has_one :user, serializer: UserSerializer

    has_one :session_score, serializer: SessionScoreSerializer

    # def question_type
    #   object.game_holder.question_type, serializer: QuestionTypeSerializer
    # end
  end
end