module Api::V1::PracticeQuestions
  class TippingOptionSerializer < PracticeOptionSerializer
    attributes :answer, :correct, :_correct, :hint, :hint_structure

    def hint
      object.option.hint
    end
  end
end