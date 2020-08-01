def print_folder_structure
  output = ""
  enabled_chaps = Chapter.where(standard: Standard.first, enabled: true)
  enabled_chaps.each do |chap|
    prefix = "#{chap.s3_slug}/"
    chap.practice_game_levels.each do |level|
      prefix = "#{prefix}#{level.s3_slug}/"
      # Character Discussion
      output += "#{prefix}d/i/\n" if !level.intro_discussion.nil?
      output += "#{prefix}d/s/\n" if !level.success_discussion.nil?
      output += "#{prefix}d/f/\n" if !level.fail_discussion.nil?
      # Questions
      level.game_questions.each do |gq|
        next if gq.question.nil? 
        output = print_question_structure(output, prefix, gq)
      end
      # Level Folder is over
      prefix = prefix.chomp("#{level.s3_slug}/")
    end
  end
  f = File.new('folder_structure.txt', 'w')
  f << output
  f.close
end

def print_question_structure output, prefix, gq 
  prefix = "#{prefix}#{gq.question.s3_slug}/"
  output += "#{prefix}\n"
  # If question has hint
  output += "#{prefix}hint/\n" if gq.question.has_hint

  # If question's options has hints
  hint_options = gq.option_hint_list
  if hint_options.count > 0
    prefix = "#{prefix}options/"
    output += "#{prefix}\n"
    hint_options.each_with_index do |op,i|
      output += "#{prefix}#{op}_op/hint/\n"
    end
    prefix = prefix.chomp("options/")
  end

  # If Game has sub_questions
  gq.sub_questions.each do |sgq|
    output = print_question_structure(output, prefix, sgq)
  end

  # Game Question folder is over
  prefix = prefix.chomp("#{gq.question.s3_slug}/")
  return output
end

# print_folder_structure

# xargs -I {} mkdir -p "{}" < folder_structure.txt 