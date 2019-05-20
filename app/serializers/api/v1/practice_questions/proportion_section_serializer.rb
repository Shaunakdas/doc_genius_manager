module Api::V1::PracticeQuestions
  class ProportionSectionSerializer < PracticeQuestionSerializer
    attributes :id, :blocks

    def blocks
      object.proportion_blocks
    end
  end
end