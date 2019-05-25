module Api::V1::PracticeQuestions
  class MarkerGapSerializer < ActiveModel::Serializer
    attributes :big, :small, :tiny
  end
end