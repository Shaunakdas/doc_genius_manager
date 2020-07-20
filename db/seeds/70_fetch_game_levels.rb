def get_game_types
  x = ""
  GameLevel.includes(:game_questions).where.not(game_questions: {id: nil}).each do |level|
    x = x + "#{level.game_holder.game.slug},#{level.practice_mode},#{level.id},#{level.game_questions.count} \n"
  end
  puts x
end

def get_level_list
  y = ""
  list = []
  User.last.enabled_chapters.each do |c|
    c.practice_game_levels.each do |level|
      y = y + "#{c.sequence_standard},#{level.id},#{level.slug},#{level.practice_mode} \n"
    end
  end
  puts y
end

# get_game_types
# get_level_list