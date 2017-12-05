module Api::V1
  class GameSessionSerializer < ActiveModel::Serializer
    attributes :id,:start, :finish, :recent_scores, :score_rank
    has_one :user, serializer: UserSerializer

    has_one :session_score, serializer: SessionScoreSerializer

    has_many :recent_scores, serializer: SessionScoreSerializer
    # def question_type
    #   object.game_holder.question_type, serializer: QuestionTypeSerializer
    # end
  end
end