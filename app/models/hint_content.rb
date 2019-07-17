class HintContent < ApplicationRecord
  belongs_to :hint
  enum position: [ :left, :right, :bottom ]
end
