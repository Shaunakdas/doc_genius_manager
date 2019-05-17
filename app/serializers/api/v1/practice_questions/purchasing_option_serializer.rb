module Api::V1::PracticeQuestions
  class PurchasingOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct
  end
end