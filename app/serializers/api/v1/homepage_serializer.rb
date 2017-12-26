module Api::V1
  class HomepageSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :sex, :birth, :standard, :recent_questions
    
    def sex
      object.sex.to_s.humanize if object.sex.present? 
    end
    
    def standard
      StandardSerializer.new(object.standard, scope: scope, root: false)
    end
    has_many :recent_questions, serializer: QuestionTypeSerializer
  end
end