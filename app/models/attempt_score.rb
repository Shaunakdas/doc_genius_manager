class AttemptScore < ApplicationRecord
  belongs_to :attempt_item, polymorphic: true
end
