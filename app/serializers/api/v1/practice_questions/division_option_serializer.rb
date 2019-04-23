module Api::V1::PracticeQuestions
  class DivisionOptionSerializer < PracticeOptionSerializer
    attributes :type, :display, :value
  end
end