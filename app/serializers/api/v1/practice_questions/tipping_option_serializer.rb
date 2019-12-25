module Api::V1::PracticeQuestions
  class TippingOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct, :_correct
  end
end