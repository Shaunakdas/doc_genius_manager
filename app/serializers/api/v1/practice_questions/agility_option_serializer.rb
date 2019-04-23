module Api::V1::PracticeQuestions
  class AgilityOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct
  end
end