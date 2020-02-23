module Api::V1::PracticeQuestions
  class DivisionOptionSerializer < PracticeOptionSerializer
    attributes :type, :_type, :display, :value, :count
    def _type
      "dropdown,int,math"
    end

    def count
      object.option.display_index
    end
  end
end