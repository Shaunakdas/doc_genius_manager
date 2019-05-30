module Api::V1::PracticeQuestions
  class RefinementContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title
  end
end