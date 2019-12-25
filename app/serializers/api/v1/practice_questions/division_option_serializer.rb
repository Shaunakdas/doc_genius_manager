module Api::V1::PracticeQuestions
  class DivisionOptionSerializer < PracticeOptionSerializer
    attributes :type, :_type, :display, :value
    def _type
      "dropdown,int,math"
    end
  end
end