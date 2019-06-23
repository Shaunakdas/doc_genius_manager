module Api::V1
  class AttemptScoreSerializer < ActiveModel::Serializer
    attributes :time_spent, :correct_count, :displayed, :passed

  end
end