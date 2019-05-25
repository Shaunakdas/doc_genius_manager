module Api::V1::PracticeQuestions
  class EstimationAnswerSerializer < PracticeOptionSerializer
    attributes :index, :title, :sub_title
    
    def index
      object.option.display_index
    end

    def title
      object.option.display
    end

    def sub_title
      object.option.sub_title
    end
  end
end