module Api::V1::PracticeQuestions
  class RefinementOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct
  end
end