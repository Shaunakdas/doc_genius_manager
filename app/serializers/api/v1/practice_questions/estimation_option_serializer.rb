module Api::V1::PracticeQuestions
  class EstimationOptionSerializer < PracticeOptionSerializer
    attributes :index, :display
    
    def index
      object.option.display_index
    end

    def display
      object.option.display
    end
  end
end