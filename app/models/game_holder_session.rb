class GameHolderSession < ApplicationRecord
  belongs_to :game_holder
  belongs_to :user
  enum completion_status: [ :created, :started, :completed]
  enum attempt_type: [ :homework, :permanent, :live]
end
