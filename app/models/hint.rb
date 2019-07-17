class Hint < ApplicationRecord
  belongs_to :acad_entity, polymorphic: true

  has_many :hint_contents
end
