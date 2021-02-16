module Api::V1
  class GameSessionSerializer < ActiveModel::Serializer
    attributes :id,:start, :finish, :recent_scores, :game_question_attempts
    has_one :user, serializer: UserSerializer

    has_one :attempt_score, serializer: AttemptScoreSerializer

    has_many :game_question_attempts, serializer:  GameQuestionAttemptSerializer
  end
end