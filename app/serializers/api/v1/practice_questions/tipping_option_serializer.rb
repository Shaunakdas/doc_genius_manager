module Api::V1::PracticeQuestions
  class TippingOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct
  end
end