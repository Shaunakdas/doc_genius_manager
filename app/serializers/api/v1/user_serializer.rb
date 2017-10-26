module Api::V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :sex, :birth, :standard
    def sex
      object.sex.to_s.humanize if object.sex.present? 
    end
    def standard
      profile = object.acad_profiles.where(acad_entity_type: 'Standard').first
      if profile
        # standard = Standard.find(profile.acad_entity_id)
        if standard
          StandardSerializer.new(object.standard, scope: scope, root: false)
        end
      end
    end

  end
end
