module Api::V1
  class AttemptScoreSerializer < ActiveModel::Serializer
    attributes :time_spent, :correct_count, :displayed, :passed, :normal_marks, :speedy_marks, :total_value

  end
end