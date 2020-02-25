x = ""
GameLevel.includes(:game_questions).where.not(game_questions: {id: nil}).each do |level|
  x = x + "#{level.game_holder.game.slug},#{level.practice_mode},#{level.id},#{level.game_questions.count} \n"
end
puts x