module Api::V1::PracticeQuestions
  class ConversionOptionSerializer < PracticeOptionSerializer
    attributes :upper, :lower, :sequence
  end
end