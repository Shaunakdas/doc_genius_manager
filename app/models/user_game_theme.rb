class UserGameTheme < ApplicationRecord
  belongs_to :game_theme
  belongs_to :user
end
