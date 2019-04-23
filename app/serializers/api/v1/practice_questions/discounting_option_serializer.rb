module Api::V1::PracticeQuestions
  class DiscountingOptionSerializer < PracticeOptionSerializer
    attributes :upper, :lower, :after_attempt, :sequence
  end
end