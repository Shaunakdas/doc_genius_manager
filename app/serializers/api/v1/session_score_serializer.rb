module Api::V1
  class SessionScoreSerializer < ActiveModel::Serializer
    attributes :value, :time_taken, :correct_count, :incorrect_count, :seen, :passed, :failed
  end
end