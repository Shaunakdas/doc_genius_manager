module Api::V1::PracticeQuestions
  class RefinementOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct, :_correct
  end
end