module Api::V1::PracticeQuestions
  class TippingOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct, :_correct, :hint

    def hint
      object.option.hint
    end
  end
end