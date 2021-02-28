def parse_game_theme
  require "json"
  file = File.open "db/seeds/game_themes.json"
  game_themes = JSON.load file
  if GameTheme.count == 0
    game_themes.each do |game_theme|
      GameTheme.create!(title: game_theme["title"], payload: game_theme);
    end
  end

end
# parse_game_theme