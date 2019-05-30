module Api::V1::PracticeQuestions
  class DivisionContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title

    def sub_title
      object.question.solution
    end
  end
end