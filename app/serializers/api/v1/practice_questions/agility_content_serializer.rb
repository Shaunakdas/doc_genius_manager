module Api::V1::PracticeQuestions
  class AgilityContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title
  end
end