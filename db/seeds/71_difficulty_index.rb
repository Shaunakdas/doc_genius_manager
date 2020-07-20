def set_difficulty_index game_holder 
  i = 1
  game_holder.game_questions.each do |game_question|
    game_question.update_attributes!(difficulty_index: i)
    i = i +1
  end
end

def set_all_difficulty_index
  GameHolder.all.each do |game_holder|
    set_difficulty_index(game_holder)
  end
end

# set_all_difficulty_index