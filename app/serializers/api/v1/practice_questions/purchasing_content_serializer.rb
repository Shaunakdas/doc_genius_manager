module Api::V1::PracticeQuestions
  class PurchasingContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title
  end
end