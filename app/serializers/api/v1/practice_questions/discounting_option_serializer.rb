module Api::V1::PracticeQuestions
  class DiscountingOptionSerializer < PracticeOptionSerializer
    attributes :upper, :lower, :attempted, :sequence

    def attempted
      object.option.after_attempt
    end
  end
end