module Api::V1::PracticeQuestions
  class ProportionOptionSerializer < PracticeOptionSerializer
    attributes :title, :value, :display,  :hint
  end
end