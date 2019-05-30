module Api::V1::PracticeQuestions
  class DictionContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title
  end
end