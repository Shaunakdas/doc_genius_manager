module Api::V1
  class GameQuestionAttemptSerializer < ActiveModel::Serializer
    attributes :id,:time_attempt, :passed

    has_one :attempt_score, serializer: AttemptScoreSerializer
  end
end