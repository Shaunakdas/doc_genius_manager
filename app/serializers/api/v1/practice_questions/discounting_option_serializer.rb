module Api::V1::PracticeQuestions
  class DiscountingOptionSerializer < PracticeOptionSerializer
    attributes :upper, :lower, :attempted, :sequence, :_sequence

    def attempted
      object.option.after_attempt.nil? ? object.option.upper : object.option.after_attempt
    end
  end
end