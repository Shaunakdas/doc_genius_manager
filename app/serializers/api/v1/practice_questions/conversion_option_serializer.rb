module Api::V1::PracticeQuestions
  class ConversionOptionSerializer < PracticeOptionSerializer
    attributes :upper, :lower, :sequence, :_sequence, :hint, :hint_structure
  end
end