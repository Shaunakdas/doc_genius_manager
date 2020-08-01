require 'rubyXL'
# require 'html_press'
# require 'nokogiri'

# book = RubyXL::Parser.parse('db/seeds/excels/WorkingRules_Shaunak_v0.14.xlsx')
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')



def remove_game_question_references
  GameHolder.all.each do |g|
    g.remove_game_questions
  end
end

def remove_game_holder_questions(name)
  game= PracticeType.find_by(slug: name)
  return nil if game.nil?
  GameHolder.where(game_id: game.id).each do |g|
    g.remove_game_questions
    puts "Removed game question refs of gameholder : #{g.name}"
    g.game_levels.each do |g|
      g.remove_game_questions
      puts "Removed game level refs of game_level : #{g.name}"
    end
  end
  Question.search_prefix(name).each do |q|
    q.update_attributes!(code: nil)
  end
end

def remove_game_holder_references
  Chapter.all.each do |c|
    c.remove_game_holders
  end
end

def remove_question_code(code)
  Question.search_code(code).each do |q|
    q.update_attributes!(code: nil)
  end
end

# remove_question_code(parent_code)
# remove_question_code(code)

# # Uploading basic acad entities
# def upload_basic_acad_entity(book, count)
#   master_sheet = book[count]
#   master_sheet.each do |row|


#     if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'

#       standard_name = (row.cells[0].value[1..-1].to_s).to_i.to_s
#       standard_slug = standard_name

#       subject_name = row.cells[1].value
#       subject_slug = row.cells[2].value

#       stream_name = row.cells[4].value
#       stream_slug = row.cells[5].value

#       chapter_sequence = row.cells[7].value
#       chapter_name = row.cells[8].value
#       chapter_slug = row.cells[9].value

#       topic_sequence = row.cells[11].value
#       topic_name = row.cells[12].value
#       topic_slug = row.cells[13].value

#       if row.cells[15]
#         sub_topic_sequence = row.cells[14].value
#         sub_topic_name = row.cells[15].value
#         sub_topic_slug = row.cells[16].value
#       end

#       if row.cells[18]
#         question_type_sequence = row.cells[17].value
#         question_type_name = row.cells[18].value
#         question_type_slug = row.cells[19].value
#       end

#       if row.cells[27] && row.cells[25]
#         working_rule_ques = row.cells[27].value
#         working_rule_name = row.cells[25].value
#         working_rule_slug = row.cells[26].value

#         game_holder_name = row.cells[22].value
#         game_holder_slug = row.cells[23].value
#       end

#       #Create or find stream
#       if not standard = Standard.find_by(:slug => standard_slug)
#         puts "Adding Standard #{standard_name}"
#         standard = Standard.create!(:name => standard_name, :slug => standard_slug)
#       end

#       #Create or find stream
#       if not subject = Subject.find_by(:slug => subject_slug)
#         puts "Adding Subject #{subject_name}"
#         subject = Subject.create!(:name => subject_name, :slug => subject_slug)
#       end

#       #Create or find stream
#       if not stream = Stream.find_by(:slug => stream_slug)
#         puts "Adding stream #{stream_name}"
#         stream = Stream.create!(:name => stream_name, :slug => stream_slug, :subject => subject)
#       end

#       #Create or find chapter
#       if (not chapter = Chapter.find_by(:slug => chapter_slug)) && chapter_name
#         puts "Adding chapter #{chapter_name}"
#         chapter = Chapter.create!(:name => chapter_name, :slug => chapter_slug,
#         :stream => stream, :standard => standard, :sequence_standard => standard.chapters.length+1,
#         :sequence_stream => stream.chapters.length+1)
#       end

#       #Create or find topic
#       if (not topic = Topic.find_by(:slug => topic_slug)) && topic_name  && chapter
#         puts "Adding topic #{topic_name}, slug: #{topic_slug}"
#         topic = Topic.create!(:name => topic_name, :slug => topic_slug, :chapter => chapter,
#           :sequence => chapter.topics.length+1)
#       end

#       #Create or find sub_topic
#       if (not sub_topic = SubTopic.find_by(:slug => sub_topic_slug)) && sub_topic_name && topic
#         puts "Adding sub_topic #{sub_topic_name}, slug: #{sub_topic_slug}"
#         sub_topic = SubTopic.create!(:name => sub_topic_name, :slug => sub_topic_slug, :topic => topic,
#           :sequence => topic.sub_topics.length+1)
#       end

#       #Create or find question_type 
#       if (not question_type = QuestionType.find_by(:slug => question_type_slug)) && question_type_name && (question_type_name.length > 3) && sub_topic
#         puts "Adding question_type #{question_type_name} , slug: #{question_type_slug}"
#         question_type = QuestionType.create!(:name => question_type_name, :slug => question_type_slug, :sub_topic => sub_topic,
#           :sequence => sub_topic.question_types.length+1)
#       end

#       diff = DifficultyLevel.last
#       #Create or find working_rule 
#       if (not working_rule = WorkingRule.find_by(:slug => working_rule_slug)) && working_rule_name && (working_rule_name.length > 3) && question_type
#         puts "Adding working_rule #{working_rule_name} , slug: #{working_rule_slug}"
#         working_rule = WorkingRule.create!(:name => working_rule_name, :slug => working_rule_slug,
#           :question_text => working_rule_ques, :difficulty_level => diff)
        
#         game_holder = GameHolder.create!(:name => game_holder_name, :slug => game_holder_slug, :question_type => question_type,
#           :game => working_rule, :sequence => question_type.game_holders.length+1)
#       end

#     end
#     break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
#   end
# end

# # # Practice Game
# def upload_practice_types(book, count)
#   master_sheet = book[count]
#   master_sheet.each do |row|
#     if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'

#       chapter_slug = row.cells[9].value

#       topic_name = row.cells[12].value
#       topic_slug = row.cells[13].value

#       if row.cells[16] && row.cells[16].value
#         practice_type_name = row.cells[16].value
#         practice_type_slug = practice_type_name.downcase
#         game_holder_name = row.cells[21].value
#         game_holder_slug = row.cells[22].value
#       end

#       topic = Topic.find_by(:slug => topic_slug)
#       if topic.nil?
#         chapter = Chapter.find_by(:slug => chapter_slug)
#         puts "Adding topic #{topic_name}, slug: #{topic_slug}"
#         topic = Topic.create!(:name => topic_name, :slug => topic_slug, :chapter => chapter,
#           :sequence => chapter.topics.length+1)
#       end

#       #Create or find practice_type 
#       if (not practice_type = PracticeType.find_by(:slug => practice_type_slug)) && practice_type_name && (practice_type_name.length > 2) && topic
#         puts "Adding practice_type #{practice_type_name} , slug: #{practice_type_slug}"
#         practice_type = PracticeType.create!(:name => practice_type_name, :slug => practice_type_slug)
        
#       end

#       if (not game_holder = GameHolder.find_by(:slug => game_holder_slug)) && game_holder_name && practice_type && topic 
#         puts "Adding game_holder #{game_holder_name} , slug: #{game_holder_slug}"
#         game_holder = GameHolder.create!(:name => game_holder_name, :slug => game_holder_slug, acad_entity: topic,
#           :game => practice_type)
#       elsif !game_holder.nil?
#         game_holder.update_attributes!(acad_entity: topic)
#       end

#     end
#     break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
#   end
# end


# # # GameHolder Details
# def upload_game_holder_details(book, count)
#   master_sheet = book[count]
#   master_sheet.each do |row|
#     if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'

#       if row.cells[16] && row.cells[16].value
#         practice_type_name = row.cells[16].value
#         practice_type_slug = practice_type_name.downcase
#         game_holder_name = row.cells[21].value
#         game_holder_slug = row.cells[22].value
#         game_holder_sequence = row.cells[19].value
#         game_holder_title = row.cells[23].value
#       end

#       game_holder = GameHolder.find_by(:slug => game_holder_slug)

#       if game_holder && game_holder_sequence && game_holder_title
#         game_holder.update_attributes!(title: game_holder_title, sequence: game_holder_sequence)
#       end

#     end
#     break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
#   end
# end

# def set_acad_entity_enabled(enabled)
#   Topic.all.each do |topic|
#     topic.update_attributes!(enabled: true) if topic.practice_game_holders.length > 0
#   end

#   Chapter.all.each do |chapter|
#     chapter.update_attributes!(enabled: true) if chapter.practice_game_holders.length > 0
#   end
# end


# PG: Agility
def upload_agility_data(book, count)
  remove_game_holder_questions("agility") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value && (row.cells[0].value.is_a? String) && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          solution = row.cells[question_start + 2].value if row.cells[question_start + 4]
          post_submit_text = row.cells[question_start + 3].value
          mode = row.cells[question_start + 4].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, solution: solution,
          post_submit_text: post_submit_text, mode: mode, code: code)
          puts "Adding question code: #{code} ,display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
          option_start = 9
          option_width = 2
          option_count = 4
          (0..(option_count-1)).each do |counter|
            display_index = option_start + (counter*option_width)
            correct_index = option_start + (counter*option_width) +  1

            if row.cells[display_index].value
              display = row.cells[display_index].value
              correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value

              option = Option.create( display: display, correct: (correct==1))
              puts "Adding option_#{(option_count+1)} display: #{display} , correct: #{correct}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("agility")
  update_gameholder_question_text("agility")
end



# PG: Purchasing
def upload_purchasing_data(book, count)
  remove_game_holder_questions("purchasing") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value && (row.cells[0].value.is_a? String) && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          solution = row.cells[question_start + 2].value if row.cells[question_start + 2]
          title = row.cells[question_start + 3].value
          mode = row.cells[question_start + 4].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, solution: solution,
          title: title, mode: mode, code: code)
          puts "Adding question code: #{code} ,display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
          option_start = 9
          option_width = 2
          option_count = 4
          (0..(option_count-1)).each do |counter|
            display_index = option_start + (counter*option_width)
            correct_index = option_start + (counter*option_width) +  1

            if row.cells[display_index]
              display = row.cells[display_index].value
              correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value

              option = Option.create( display: display, correct: (correct==1))
              puts "Adding option_#{(option_count+1)} display: #{display} , correct: #{correct}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("purchasing")
  update_gameholder_question_text("purchasing")
end


# PG: Conversion
def upload_conversion_data(book, count)
  remove_game_holder_questions("conversion") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          solution = nil
          solution = row.cells[question_start + 2].value if row.cells[question_start + 2]

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, solution: solution, code: code)
          puts "Adding question code: #{code} , display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)

          option_start = 7
          option_width = 4
          option_count = 5
          (0..(option_count-1)).each do |counter|
            upper_index = option_start + (counter*option_width)
            lower_index = option_start + (counter*option_width) +  1
            sequence_index = option_start + (counter*option_width) +  2
            hint_index = option_start + (counter*option_width) +  3

            if row.cells[upper_index] && row.cells[upper_index].value
              upper = row.cells[upper_index].value
              lower = row.cells[lower_index].value
              sequence = row.cells[sequence_index].value
              hint = row.cells[hint_index]? row.cells[hint_index].value : nil

              option = Option.create( upper: upper, lower: lower, sequence: sequence, hint: hint)
              puts "Adding option_#{(option_count+1)} upper: #{upper}, lower: #{lower}, sequence: #{sequence}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("conversion")
  update_gameholder_question_text("conversion")
end

# PG: Diction
def upload_diction_data(book, count)
  remove_game_holder_questions("diction") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)
        
        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          hint = row.cells[question_start + 2].value
          solution = row.cells[question_start + 3].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, hint: hint, solution: solution, code: code)
          puts "Adding question code: #{code} , display: #{display} , hint: #{hint}, solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
          option_start = 8
          option_width = 1
          option_count = 1
          (0..(option_count-1)).each do |counter|
            correct_index = option_start + (counter*option_width)

            if row.cells[correct_index] && row.cells[correct_index].value
              correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value

              option = Option.create!( correct: (correct=="TRUE")||(correct==1))
              puts "Adding option_#{(option_count+1)} correct: #{(correct=="TRUE")||(correct==1)}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("diction")
  update_gameholder_question_text("diction")
end

# PG: Discounting
def upload_discounting_data(book, count)
  remove_game_holder_questions("discounting") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          solution = row.cells[question_start + 2].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, solution: solution, code: code)
          puts "Adding question code: #{code} , display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
          option_start = 7
          option_width = 4
          option_count = 5
          (0..(option_count-1)).each do |counter|
            upper_index = option_start + (counter*option_width)
            lower_index = option_start + (counter*option_width) +  1
            after_attempt_index = option_start + (counter*option_width) +  2
            sequence_index = option_start + (counter*option_width) +  3

            if row.cells[upper_index] && row.cells[upper_index].value
              upper = row.cells[upper_index].value
              lower = row.cells[lower_index].value
              after_attempt = row.cells[after_attempt_index].value
              sequence = row.cells[sequence_index].value

              option = Option.create( upper: upper, lower: lower, after_attempt: after_attempt, sequence: sequence)
              puts "Adding option_#{(option_count+1)} upper: #{upper}, lower: #{lower}, after_attempt: #{after_attempt}, sequence: #{sequence}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("discounting")
  update_gameholder_question_text("discounting")
end

# PG: Division
def upload_division_data(book, count)
  remove_game_holder_questions("division") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          hint = row.cells[question_start + 2]? row.cells[question_start + 2].value : nil
          solution = row.cells[question_start + 3].value
          mode = row.cells[question_start + 4].value
          post_submit_text = row.cells[question_start + 5].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)
          
          question = Question.create!(display: display, hint: hint, solution: solution, mode: mode, code: code)
          puts "Adding question code: #{code} , display: #{display} , hint: #{hint}, solution: #{solution} , mode: #{mode}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
          option_start = 10
          option_width = 4
          option_count = 5
          (0..(option_count-1)).each do |counter|
            value_type_index = option_start + (counter*option_width)
            display_index = option_start + (counter*option_width) +  1
            value_index = option_start + (counter*option_width) +  2
            display_count_index = option_start + (counter*option_width) +  3

            if row.cells[value_type_index] && row.cells[value_type_index].value
              value_type = row.cells[value_type_index].value
              display = row.cells[display_index].value
              value = row.cells[value_index].value
              display_count = row.cells[display_count_index].value

              option = Option.create( value_type: value_type, display: display, value: value, display_index: display_count)
              puts "Adding option_#{(option_count+1)} value_type: #{value_type}, display: #{display}, value: #{value}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("division")
  update_gameholder_question_text("division")
end

# PG: Estimation
def upload_estimation_data(book, count)
  remove_game_holder_questions("estimation") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          tip = row.cells[question_start + 2]? row.cells[question_start + 2].value : nil
          solution = row.cells[question_start + 3].value
          post_submit_text = row.cells[question_start + 4].value
          mode = row.cells[question_start + 7].value

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          number_line_index = question_start + 8

          big_gap = row.cells[number_line_index + 2]? row.cells[number_line_index + 2].value : nil
          small_gap = row.cells[number_line_index + 3]? row.cells[number_line_index + 3].value : nil
          tiny_gap = row.cells[number_line_index + 4]? row.cells[number_line_index + 4].value : nil

          marker_gap = MarkerGap.create!( big: big_gap, small: small_gap, tiny: tiny_gap)

          question = Question.create!(display: display, code: code, tip: tip,
            post_submit_text: post_submit_text, solution: solution, mode: mode, marker_gap: marker_gap)
          puts "Adding question code: #{code} , display: #{display} , tip: #{tip}, post_submit_text: #{post_submit_text},
            solution: #{solution} , mode: #{mode}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)

          answer_index = number_line_index + 5
          answer_title = number_line_index + 6
          answer_sub_title = number_line_index + 7

          display_index = row.cells[answer_index].value
          value = row.cells[answer_title].value
          sub_title = row.cells[answer_sub_title].value

          option = Option.create( display_index: display_index, display: value, sub_title: sub_title, correct: true)
          puts "Adding option, id: #{option.id} display_index: #{answer_index}, value: #{value}, sub_title: #{sub_title}"
          game_option = GameOption.create!(option: option, game_question: game_question)

          option_start = number_line_index + 8
          option_width = 2
          option_count = 12
          (0..(option_count-1)).each do |counter|
            display_index_index = option_start + (counter*option_width)
            value_index = option_start + (counter*option_width) +  1

            if row.cells[value_index] && row.cells[value_index].value
              display_index = row.cells[display_index_index].value
              value = row.cells[value_index].value

              option = Option.create( display_index: display_index, display: value, correct: false)
              puts "Adding option_#{(option_count+1)} , display_index: #{display_index}, display: #{value}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("estimation")
  update_gameholder_question_text("estimation")
end


# PG: Percentage
def upload_percentage_data(book, count)
  remove_game_holder_questions("percentages") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          tip = row.cells[question_start + 2]? row.cells[question_start + 2].value : nil
          hint = row.cells[question_start + 3]? row.cells[question_start + 3].value : nil
          solution = row.cells[question_start + 4]? row.cells[question_start + 4].value : nil
          mode = row.cells[question_start + 5]? row.cells[question_start + 5].value : nil

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, code: code, tip: tip, hint: hint, solution: solution, mode: mode)
          puts "Adding question code: #{code} , display: #{display} , tip: #{tip}, hint: #{hint}, solution: #{solution}, mode: #{mode}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("percentage")
  update_gameholder_question_text("percentage")
end

# PG: SCQ
def upload_tipping_data(book, count)
  remove_game_holder_questions("tipping") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          code = row.cells[question_start].value
          display = row.cells[question_start + 1].value
          tip = row.cells[question_start + 2].value
          hint = row.cells[question_start + 3]? row.cells[question_start + 3].value : nil
          title = row.cells[question_start + 4].value
          solution = row.cells[question_start + 5]? row.cells[question_start + 5].value : nil

          break if Question.search_code(code).count > 0
          # remove_question_code(code)

          question = Question.create!(display: display, code: code, tip: tip, hint: hint, title: title, solution: solution)
          puts "Adding question code: #{code} , display: #{display} , tip: #{tip}, hint: #{hint}, title: #{title},
          solution: #{solution}, game_level: #{game_level.id}, game_holder: #{game_holder.id}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder,
            difficulty_index: difficulty, game_level: game_level)
          puts "Added Tipping GameQuestion #{game_question.to_json}"
          option_start = 10
          option_width = 3
          option_count = 9
          (0..(option_count-1)).each do |counter|
            display_index = option_start + (counter*option_width)
            correct_index = option_start + (counter*option_width) +  1
            hint_index = option_start + (counter*option_width) +  2

            if  row.cells[display_index] && row.cells[display_index].value
              display = row.cells[display_index].value
              correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value
              hint = row.cells[hint_index].nil? ? nil : row.cells[hint_index].value

              option = Option.create( display: display, correct: (correct==1), hint: hint)
              puts "Adding option_#{(option_count+1)} display: #{display} , correct: #{correct}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("tipping")
  update_gameholder_question_text("tipping")
end


# PG: Inversion
def upload_inversion_data(book, count)
  remove_game_holder_questions("inversion") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)
        
        question_start = 3
        if practice_type && game_holder
          parent_code = row.cells[question_start].value
          code = row.cells[question_start + 1].value

          break if Question.search_code(code).count > 0
          parent_question = Question.where(code: parent_code).first

          display_index = question_start + 2
          if parent_question.nil? && row.cells[display_index] && row.cells[display_index].value && row.cells[display_index].value.length > 1
            display = row.cells[display_index].value

            parent_question = Question.create!(code: parent_code, display: display)
            puts "Adding parent_question code: #{parent_code},  display: #{display}"
            parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder,
              game_level: game_level)

          end

          # if !parent_game_question
          #   parent_game_question = game_holder.game_questions.first
          #   parent_question = parent_game_question.question
          # end

          if !parent_question.nil?
            parent_game_question = GameQuestion.where(question: parent_question).first
            solution = row.cells[display_index + 1]? row.cells[display_index + 1].value : nil

            question = Question.create!(code: code, display: display, solution: solution,
              parent_question: parent_question)
            puts "Adding question code: #{code}, display: #{display} , solution: #{solution}, question: #{question.id}
              parent_game_question: #{parent_game_question.id}, parent_question: #{parent_question.id}"
            game_question = GameQuestion.create!(question: question,
              parent_question: parent_game_question)
            
            option_start = 7
            option_width = 1
            option_count = 2
            (0..(option_count-1)).each do |counter|
              display_index = option_start + (counter*option_width)

              if row.cells[display_index] && row.cells[display_index].value
                display = row.cells[display_index].value

                option = Option.create( display: display)
                puts "Adding option_#{(option_count+1)} display: #{display}"
                game_option = GameOption.create!(option: option, game_question: game_question)
              end
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("inversion")
  update_gameholder_question_text("inversion")
end

# PG: Proportion
def upload_proportion_data(book, count)
  remove_game_holder_questions("proportion") if remove_game_holder_ref_flag
  master_sheet = book[count]
  sequence = -1
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        question_start = 3
        if practice_type && game_holder
          parent_code = row.cells[question_start].value
          code = row.cells[question_start + 1].value

          break if Question.search_code(parent_code).count > 0

          new_seq = row.cells[question_start + 2]? row.cells[question_start + 2].value.to_i : nil
          parent_display = row.cells[question_start + 3].value
          display = parent_display
          solution = row.cells[question_start + 5].value
          puts "new_seq : #{new_seq},sequence : #{sequence}"
          parent_game_question = GameQuestion.includes(:sub_questions).where(game_holder: game_holder).sort_by {|obj|obj.id}[new_seq-1]
          if parent_game_question.nil?
            sequence = new_seq
            parent_question = Question.create!(code: parent_code, display: parent_display, solution: solution)
            puts "Adding parent question parent_display: #{parent_display}, id: #{parent_question.id}"
            parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder,
              game_level: game_level)
            puts "Adding parent question parent_game_question: #{parent_display}, id: #{parent_game_question.id}"
          else
            parent_question = parent_game_question.question
            puts "Using parent question parent_display: #{parent_display}, id: #{parent_question.id}"
          end

          if parent_question
            parent_game_question = GameQuestion.where(question: parent_question, game_holder: game_holder).first
            question = Question.create!(code: code, display: display, solution: solution, parent_question: parent_question)
            puts "Adding question id: #{question.id}, display: #{display} , solution: #{solution}, parent_question_id: #{parent_question.id}"
            game_question = GameQuestion.create!(question: question, parent_question: parent_game_question)
            puts "Adding game_question id: #{game_question.id}, display: #{display} , solution: #{solution}, parent_question_id: #{parent_game_question.id}"
            
            option_start = 9
            option_width = 4
            option_count = 5
            (0..(option_count-1)).each do |counter|
              display_index = option_start + (counter*option_width)
              hint_index = option_start + (counter*option_width) +  1
              title_index = option_start + (counter*option_width) +  2
              value_type_index = option_start + (counter*option_width) +  3

              if row.cells[display_index] && row.cells[display_index].value
                display = row.cells[display_index].value
                hint = row.cells[hint_index].value
                title = row.cells[title_index].value
                value_type = row.cells[value_type_index].value

                option = Option.create( display: display, hint: hint, title: title, value_type: value_type)
                puts "Adding option_#{(option_count+1)} display: #{display}, hint: #{hint}, title: #{title}, value_type: #{value_type}, game_question: #{game_question.id}"
                game_option = GameOption.create!(option: option, game_question: game_question)
              end
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("proportion")
  update_gameholder_question_text("proportion")
end

def check_gameholder_question game_holder, display
  game_holder.game_questions.each do |g_q|
    return g_q if g_q.question.display == display
  end
  return nil
end



# PG: Refinement
def upload_refinement_data(book, count)
  remove_game_holder_questions("refinement") if remove_game_holder_ref_flag
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value && (row.cells[0].value.to_s.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)
        
        difficulty = row.cells[3].value
        
        question_start = 4
        if practice_type && game_holder
          parent_code = row.cells[question_start].value
          code = row.cells[question_start + 1].value

          break if Question.search_code(parent_code).count > 0
          # remove_question_code(parent_code)
          # remove_question_code(code)

          if row.cells[question_start + 2]
            parent_display = row.cells[question_start + 2].value

            parent_game_question = check_gameholder_question(game_holder, parent_display)

            if parent_game_question.nil?
              parent_question = Question.create!(display: parent_display, code: parent_code)
              puts "Adding parent_question code: #{parent_code}, display: #{parent_display}"
              parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder,
                difficulty_index: difficulty, game_level: game_level)
            end
            parent_question = parent_game_question.question
          end

          if parent_game_question
            display = row.cells[question_start + 3]? row.cells[question_start + 3].value : nil
            title = row.cells[question_start + 4]? row.cells[question_start + 4].value : nil
            solution = row.cells[question_start + 5]? row.cells[question_start + 5].value : nil

            question = Question.create!(code: code, display: display, solution: solution, title: title,
              parent_question: parent_question)
            puts "Adding question code: #{code}, display: #{display} , solution: #{solution}, question: #{question.id}
              parent_game_question: #{parent_game_question.id}, parent_question: #{parent_question.id}"
            game_question = GameQuestion.create!(question: question,
              parent_question: parent_game_question)
            
            option_start = 10
            option_width = 2
            option_count = 4
            (0..(option_count-1)).each do |counter|
              display_index = option_start + (counter*option_width)
              correct_index = option_start + (counter*option_width) + 1

              if row.cells[display_index] && row.cells[display_index].value
                display = row.cells[display_index].value
                correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value

                option = Option.create( display: display, correct: (correct==1))
                puts "Adding option_#{(option_count+1)} display: #{display}"
                game_option = GameOption.create!(option: option, game_question: game_question)
              end
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  update_gameholder_option_text("refinement")
  update_gameholder_question_text("refinement")
end

# PG: SCQ
def upload_dragonbox_data(book, count)
  remove_game_holder_questions("dragonbox")
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && row.cells[3]  && row.cells[3].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_slug = row.cells[1].value
        game_level_slug = row.cells[0].value

        game_level = GameLevel.find_by(:slug => game_level_slug)
        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          parent_mode = row.cells[3].value
          parent_setup = row.cells[4].value
          parent_steps = row.cells[5]? row.cells[5].value.to_i : nil

          parent_question = Question.create!(mode: parent_mode, steps: parent_steps, setup: parent_setup)
          puts "Adding parent_question mode: #{parent_mode}"
          parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder)

          left_start = 6
          left_fraction_start = 7
          left_fraction_count = 2
          right_start = 11
          right_fraction_start = 12
          right_fraction_count = 2
          bottom_start = 16

          left_ref_ids = row.cells[left_start]? row.cells[left_start].value : nil
          right_ref_ids = row.cells[right_start]? row.cells[right_start].value : nil
          bottom_ref_ids = row.cells[bottom_start]? row.cells[bottom_start].value : nil

          # Left Section
          set_options(parent_question, :left, algebra_options(left_ref_ids)) if !left_ref_ids.nil?
          (0..(left_fraction_count-1)).each do |counter|
            upper_index = left_fraction_start + (counter*2)
            lower_index = left_fraction_start + (counter*2) +  1

            if  row.cells[upper_index] && row.cells[upper_index].value
              upper_ids = row.cells[upper_index].value
              lower_ids = row.cells[lower_index].value

              set_fraction_option(parent_question, :left, algebra_options(upper_ids), algebra_options(lower_ids))
            end
          end

          # Right Section
          set_options(parent_question, :right, algebra_options(right_ref_ids)) if !right_ref_ids.nil?
          (0..(right_fraction_count-1)).each do |counter|
            upper_index = right_fraction_start + (counter*2)
            lower_index = right_fraction_start + (counter*2) +  1

            if  row.cells[upper_index] && row.cells[upper_index].value
              upper_ids = row.cells[upper_index].value
              lower_ids = row.cells[lower_index].value

              set_fraction_option(parent_question, :right, algebra_options(upper_ids), algebra_options(lower_ids))
            end
          end

          # Bottom Section
          set_options(parent_question, :bottom, algebra_options(bottom_ref_ids)) if !bottom_ref_ids.nil?

          hint_start = 18
          hint_type = row.cells[hint_start].value

          hint = Hint.create!(value_type: hint_type, acad_entity: parent_game_question) if hint_type

          if hint
            hint_content_start = 19
            hint_content_width = 2
            hint_content_count = 2

            (0..(hint_content_count-1)).each do |counter|
              display_index = hint_content_start + (counter*hint_content_width)
              position_index = hint_content_start + (counter*hint_content_width) +  1

              if  row.cells[display_index] && row.cells[display_index].value
                display = row.cells[display_index].value
                position = row.cells[position_index].value

                puts "Adding hint_#{(counter+1)} display: #{display} , position: #{position}"
                hint_content = hint.hint_contents.create!(display: display, position: position)
              end
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
  # update_gameholder_option_text("dragonbox")
  # update_gameholder_question_text("dragonbox")
end

def algebra_options ref_ids
  puts ref_ids
  ids = ref_ids.to_s.split(",")
  options = []
  ids.each do |id|
    ref_op = Option.where(reference_id: id).first
    options << ref_op if ref_op
  end
  return options if ids.length == options.length
  return nil
end

def get_game_question parent_ques, position
  question = parent_ques.sub_questions.where(position: position)
  game_question = GameQuestion.where(question: question).first
  if game_question.nil?
    question = Question.create!(parent_question: parent_ques, position: position)
    puts "Adding question parent_question: #{parent_ques.id} , position: #{position}"
    
    parent_game_question = GameQuestion.where(question: parent_ques).first
    game_question = GameQuestion.create!(parent_question: parent_game_question, question: question)
  end
  return game_question
end

def set_options parent_ques, position, options
  if !options.nil?
    options.each do |op|
      puts "Adding #{position.to_s} option: #{op.reference_id}" 
      game_op = GameOption.create!(option: op, game_question: get_game_question(parent_ques, position))
      puts "Added game_question: #{game_op.game_question.id} option: #{game_op.option.reference_id}" 
    end
  end
end

def set_fraction_option parent_ques, position, upper_ops, lower_ops
  fraction_op_type = OptionType.where(slug: "fraction").first
  return nil if fraction_op_type.nil?
  fraction_op = GameOption.create!(game_question: get_game_question(parent_ques, position), option_type: fraction_op_type)
  upper_ops.each do |op|
    puts "Adding #{position.to_s} upper option: #{op.reference_id}" 
    game_op = GameOption.create!(option: op, position: :numerator, parent_option: fraction_op)
  end if !upper_ops.nil?
  lower_ops.each do |op|
    puts "Adding #{position.to_s} lower option: #{op.reference_id}" 
    game_op = GameOption.create!(option: op, position: :denominator, parent_option: fraction_op)
  end if !lower_ops.nil?
end

def change_game_holder_enabled_status(enabled)
  GameHolder.joins(:game_questions).group('game_holders.id').each do |g_h|
    g_h.update_attributes!(enabled: enabled)
    puts "Enabling GameHolder: #{g_h.name}" 
  end
end

def change_game_level_enabled_status(enabled)
  GameLevel.joins(:game_questions).group('game_levels.id').each do |g_l|
    g_l.update_attributes!(enabled: enabled)
    puts "Enabling GameLevel: #{g_l.name}" 
  end
end

def set_game_holder_title
  GameHolder.all.each do |g_h|
    g_h.update_attributes!(title: "#{g_h.game.name} GameHolder")
    puts "Setting title of GameHolder: #{g_h.name}" 
  end
end

def update_question_text
  GameHolder.all.each do |g|
    g.game_questions.each do |g_q|
      replace_question_slash(g_q.question)
      g_q.sub_questions.each do |s_q|
        replace_question_slash(s_q.question)
      end
    end
  end
end

def update_gameholder_question_text(name)
  GameHolder.search(name).each do |g|
    g.game_questions.each do |g_q|
      replace_question_slash(g_q.question)
      g_q.sub_questions.each do |s_q|
        replace_question_slash(s_q.question)
      end
    end
  end
end

def update_option_text
  GameHolder.all.each do |g|
    g.game_questions.each do |g_q|
      g_q.game_options.each do |g_o|
        replace_option_slash(g_o.option)
      end
      g_q.sub_questions.each do |s_q|
        s_q.game_options.each do |s_g_o|
          replace_option_slash(s_g_o.option)
        end
      end
    end
  end
end

def update_gameholder_option_text(name)
  GameHolder.search(name).each do |g|
    g.game_questions.each do |g_q|
      g_q.game_options.each do |g_o|
        replace_option_slash(g_o.option)
      end
      g_q.sub_questions.each do |s_q|
        s_q.game_options.each do |s_g_o|
          replace_option_slash(s_g_o.option)
        end
      end
    end
  end
end

def replace_question_slash(q)
  q.display = replace_slash(q.display)
  q.hint = replace_slash(q.hint)
  # q.tip = replace_slash(q.tip)
  q.solution = replace_slash(q.solution)
  q.title = replace_slash(q.title)
  q.save!
  puts q.display if q.id == 8850
end

def replace_option_slash(o)
  o.display = replace_slash(o.display)
  o.hint = replace_slash(o.hint)
  o.upper = replace_slash(o.upper)
  o.lower = replace_slash(o.lower)
  o.value = replace_slash(o.value)
  o.after_attempt = replace_slash(o.after_attempt)
  o.title = replace_slash(o.title)
  o.save!
end

def replace_slash(text)
  if text
    new_text = text.gsub(/\\\\/, '\\')
    new_text = new_text.gsub(/<br\/>\n/, "<br/>")
    new_text = new_text.gsub(/<p\/>\n/, "<p/>")
    new_text = new_text.gsub(/\\table/, "\table")
    return new_text.gsub(/\\n/, "\n") if new_text.include?("\\n")
    return new_text
  end
  return nil
end

def remove_game_holder_ref_flag
  return true
end

def remove_question_codes
  Question.where.not(code: nil).each do |q|
    q.update_attributes!(code: nil)
  end
end

game_start = 5
# upload_basic_acad_entity(book, 0)
# upload_practice_types(book, 3)
# upload_game_holder_details(book, 3)
# set_acad_entity_enabled(true)



game_start = 5
# Once Game Levels and Game Questions are done. 
# remove_question_codes


# upload_agility_data(book, game_start)
# upload_purchasing_data(book, game_start + 1)
# upload_conversion_data(book, game_start + 2)
# upload_diction_data(book, game_start + 3)
# upload_discounting_data(book, game_start + 4)
# upload_division_data(book, game_start + 5)
# upload_estimation_data(book, game_start + 6)
upload_percentage_data(book, game_start + 7)
# upload_tipping_data(book, game_start + 8)
# upload_inversion_data(book, game_start + 9)
# upload_proportion_data(book, game_start + 10)
# upload_refinement_data(book, game_start + 11)
# upload_dragonbox_data(book, game_start + 12)
# change_game_holder_enabled_status(true)
# change_game_level_enabled_status(true)

