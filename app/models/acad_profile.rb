class AcadProfile < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true
  belongs_to :user

  def self.find_acad_entity params
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
