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
  GameHolder.search(name).each do |g|
    g.remove_game_questions
    puts "Removed game question refs of gameholder : #{g.name}"
  end
end

def remove_game_holder_references
  Chapter.all.each do |c|
    c.remove_game_holders
  end
end

# Uploading basic acad entities
def upload_basic_acad_entity(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|


    if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'

      standard_name = (row.cells[0].value[1..-1].to_s).to_i.to_s
      standard_slug = standard_name

      subject_name = row.cells[1].value
      subject_slug = row.cells[2].value

      stream_name = row.cells[4].value
      stream_slug = row.cells[5].value

      chapter_sequence = row.cells[7].value
      chapter_name = row.cells[8].value
      chapter_slug = row.cells[9].value

      topic_sequence = row.cells[11].value
      topic_name = row.cells[12].value
      topic_slug = row.cells[13].value

      if row.cells[15]
        sub_topic_sequence = row.cells[14].value
        sub_topic_name = row.cells[15].value
        sub_topic_slug = row.cells[16].value
      end

      if row.cells[18]
        question_type_sequence = row.cells[17].value
        question_type_name = row.cells[18].value
        question_type_slug = row.cells[19].value
      end

      if row.cells[27] && row.cells[25]
        working_rule_ques = row.cells[27].value
        working_rule_name = row.cells[25].value
        working_rule_slug = row.cells[26].value

        game_holder_name = row.cells[22].value
        game_holder_slug = row.cells[23].value
      end

      #Create or find stream
      if not standard = Standard.find_by(:slug => standard_slug)
        puts "Adding Standard #{standard_name}"
        standard = Standard.create!(:name => standard_name, :slug => standard_slug)
      end

      #Create or find stream
      if not subject = Subject.find_by(:slug => subject_slug)
        puts "Adding Subject #{subject_name}"
        subject = Subject.create!(:name => subject_name, :slug => subject_slug)
      end

      #Create or find stream
      if not stream = Stream.find_by(:slug => stream_slug)
        puts "Adding stream #{stream_name}"
        stream = Stream.create!(:name => stream_name, :slug => stream_slug, :subject => subject)
      end

      #Create or find chapter
      if (not chapter = Chapter.find_by(:slug => chapter_slug)) && chapter_name
        puts "Adding chapter #{chapter_name}"
        chapter = Chapter.create!(:name => chapter_name, :slug => chapter_slug,
        :stream => stream, :standard => standard, :sequence_standard => standard.chapters.length+1,
        :sequence_stream => stream.chapters.length+1)
      end

      #Create or find topic
      if (not topic = Topic.find_by(:slug => topic_slug)) && topic_name  && chapter
        puts "Adding topic #{topic_name}, slug: #{topic_slug}"
        topic = Topic.create!(:name => topic_name, :slug => topic_slug, :chapter => chapter,
          :sequence => chapter.topics.length+1)
      end

      #Create or find sub_topic
      if (not sub_topic = SubTopic.find_by(:slug => sub_topic_slug)) && sub_topic_name && topic
        puts "Adding sub_topic #{sub_topic_name}, slug: #{sub_topic_slug}"
        sub_topic = SubTopic.create!(:name => sub_topic_name, :slug => sub_topic_slug, :topic => topic,
          :sequence => topic.sub_topics.length+1)
      end

      #Create or find question_type 
      if (not question_type = QuestionType.find_by(:slug => question_type_slug)) && question_type_name && (question_type_name.length > 3) && sub_topic
        puts "Adding question_type #{question_type_name} , slug: #{question_type_slug}"
        question_type = QuestionType.create!(:name => question_type_name, :slug => question_type_slug, :sub_topic => sub_topic,
          :sequence => sub_topic.question_types.length+1)
      end

      diff = DifficultyLevel.last
      #Create or find working_rule 
      if (not working_rule = WorkingRule.find_by(:slug => working_rule_slug)) && working_rule_name && (working_rule_name.length > 3) && question_type
        puts "Adding working_rule #{working_rule_name} , slug: #{working_rule_slug}"
        working_rule = WorkingRule.create!(:name => working_rule_name, :slug => working_rule_slug,
          :question_text => working_rule_ques, :difficulty_level => diff)
        
        game_holder = GameHolder.create!(:name => game_holder_name, :slug => game_holder_slug, :question_type => question_type,
          :game => working_rule, :sequence => question_type.game_holders.length+1)
      end

    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

# # Practice Game
def upload_practice_types(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'
      topic_name = row.cells[12].value
      topic_slug = row.cells[13].value

      if row.cells[14].value
        practice_type_name = row.cells[14].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[16].value
        game_holder_slug = row.cells[17].value
      end

      topic = Topic.find_by(:slug => topic_slug)

      #Create or find practice_type 
      if (not practice_type = PracticeType.find_by(:slug => practice_type_slug)) && practice_type_name && (practice_type_name.length > 2) && topic
        puts "Adding practice_type #{practice_type_name} , slug: #{practice_type_slug}"
        practice_type = PracticeType.create!(:name => practice_type_name, :slug => practice_type_slug)
        
      end

      if (not game_holder = GameHolder.find_by(:slug => game_holder_slug)) && game_holder_name && practice_type && topic 
        puts "Adding game_holder #{game_holder_name} , slug: #{game_holder_slug}"
        game_holder = GameHolder.create!(:name => game_holder_name, :slug => game_holder_slug, acad_entity: topic,
          :game => practice_type)
      elsif !game_holder.nil?
        game_holder.update_attributes!(acad_entity: topic)
      end
      

    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

def set_acad_entity_enabled(enabled)
  Topic.all.each do |topic|
    topic.update_attributes!(enabled: true) if topic.practice_game_holders.length > 0
  end

  Chapter.all.each do |chapter|
    chapter.update_attributes!(enabled: true) if chapter.practice_game_holders.length > 0
  end
end



# PG: SCQ
def upload_scq_data(book, count)
  remove_game_holder_questions("purchasing")
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value && (row.cells[0].value.is_a? String) && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          solution = row.cells[4].value
          title = row.cells[5].value
          mode = row.cells[6].value

          question = Question.create!(display: display, solution: solution,
            title: title, mode: mode)
          puts "Adding question display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
          option_start = 7
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
end


# PG: Conversion
def upload_conversion_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          solution = nil
          solution = row.cells[4].value if row.cells[4]

          question = Question.create!(display: display, solution: solution)
          puts "Adding question display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
          option_start = 5
          option_width = 3
          option_count = 5
          (0..(option_count-1)).each do |counter|
            upper_index = option_start + (counter*option_width)
            lower_index = option_start + (counter*option_width) +  1
            sequence_index = option_start + (counter*option_width) +  2

            if row.cells[upper_index] && row.cells[upper_index].value
              upper = row.cells[upper_index].value
              lower = row.cells[lower_index].value
              sequence = row.cells[sequence_index].value

              option = Option.create( upper: upper, lower: lower, sequence: sequence)
              puts "Adding option_#{(option_count+1)} upper: #{upper}, lower: #{lower}, sequence: #{sequence}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

# PG: Diction
def upload_diction_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          hint = row.cells[4].value
          solution = row.cells[5].value

          question = Question.create!(display: display, hint: hint, solution: solution)
          puts "Adding question display: #{display} , hint: #{hint}, solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
          option_start = 6
          option_width = 1
          option_count = 1
          (0..(option_count-1)).each do |counter|
            correct_index = option_start + (counter*option_width)

            if row.cells[correct_index] && row.cells[correct_index].value
              correct = row.cells[correct_index].nil? ? 0 : row.cells[correct_index].value

              option = Option.create( correct: (correct==1))
              puts "Adding option_#{(option_count+1)} correct: #{correct}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

# PG: Discounting
def upload_discounting_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          solution = row.cells[4].value

          question = Question.create!(display: display, solution: solution)
          puts "Adding question display: #{display} , solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
          option_start = 5
          option_width = 4
          option_count = 4
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
end

# PG: Division
def upload_division_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          hint = row.cells[4]? row.cells[4].value : nil
          solution = row.cells[5].value
          mode = row.cells[6].value

          question = Question.create!(display: display, hint: hint, solution: solution, mode: mode)
          puts "Adding question display: #{display} , hint: #{hint}, solution: #{solution} , mode: #{mode}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
          option_start = 7
          option_width = 3
          option_count = 5
          (0..(option_count-1)).each do |counter|
            value_type_index = option_start + (counter*option_width)
            display_index = option_start + (counter*option_width) +  1
            value_index = option_start + (counter*option_width) +  2

            if row.cells[value_type_index] && row.cells[value_type_index].value
              value_type = row.cells[value_type_index].value
              display = row.cells[display_index].value
              value = row.cells[value_index].value

              option = Option.create( value_type: value_type, display: display, value: value)
              puts "Adding option_#{(option_count+1)} value_type: #{value_type}, display: #{display}, value: #{value}"
              game_option = GameOption.create!(option: option, game_question: game_question)
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

# PG: Estimation
# def upload_estimation_data(book, count)
#   remove_game_holder_questions("estimation")
#   master_sheet = book[count]
#   master_sheet.each do |row|
#     if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

#       if row.cells[0] && row.cells[1] && row.cells[2]
#         practice_type_name = row.cells[2].value
#         practice_type_slug = practice_type_name.downcase
#         game_holder_name = row.cells[0].value
#         game_holder_slug = row.cells[1].value

#         practice_type = PracticeType.find_by(:slug => practice_type_slug)
#         game_holder = GameHolder.find_by(:slug => game_holder_slug)

#         if practice_type && game_holder
#           display = row.cells[3].value
#           hint = row.cells[4]? row.cells[4].value : nil
#           solution = row.cells[5].value
#           mode = row.cells[6].value

#           question = Question.create!(display: display, hint: hint, solution: solution, mode: mode)
#           puts "Adding question display: #{display} , hint: #{hint}, solution: #{solution} , mode: #{mode}"
#           game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
#           option_start = 7
#           option_width = 3
#           option_count = 5
#           (0..(option_count-1)).each do |counter|
#             value_type_index = option_start + (counter*option_width)
#             display_index = option_start + (counter*option_width) +  1
#             value_index = option_start + (counter*option_width) +  2

#             if row.cells[value_type_index] && row.cells[value_type_index].value
#               value_type = row.cells[value_type_index].value
#               display = row.cells[display_index].value
#               value = row.cells[value_index].value

#               option = Option.create( value_type: value_type, display: display, value: value)
#               puts "Adding option_#{(option_count+1)} value_type: #{value_type}, display: #{display}, value: #{value}"
#               game_option = GameOption.create!(option: option, game_question: game_question)
#             end
#           end
#         end
#       end
      
#     end
#     break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
#   end
# end


# PG: Inversion
def upload_inversion_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          if row.cells[3]
            display = row.cells[3].value

            parent_question = Question.create!(display: display)
            puts "Adding parent_question display: #{display}"
            parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder)

          end

          if !parent_game_question
            parent_game_question = game_holder.game_questions.first
            parent_question = parent_game_question.question
          end

          if parent_game_question
            solution = row.cells[4]? row.cells[4].value : nil

            question = Question.create!(display: display, solution: solution,
              parent_question: parent_question)
            puts "Adding question display: #{display} , solution: #{solution}, question: #{question.id}
              parent_game_question: #{parent_game_question.id}, parent_question: #{parent_question.id}"
            game_question = GameQuestion.create!(question: question,
              parent_question: parent_game_question)
            
            option_start = 5
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
end


# PG: Percentage
def upload_percentage_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          tip = row.cells[4]? row.cells[4].value : nil
          hint = row.cells[5]? row.cells[5].value : nil
          solution = row.cells[6]? row.cells[6].value : nil

          question = Question.create!(display: display, tip: tip, hint: hint, solution: solution)
          puts "Adding question display: #{display} , tip: #{tip}, hint: #{hint}, solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)
          
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

# PG: Proportion
def upload_proportion_data(book, count)
  
  master_sheet = book[count]
  sequence = -1
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          new_seq = row.cells[3]? row.cells[3].value.to_i : nil
          parent_display = row.cells[4].value
          display = parent_display
          solution = nil

          if new_seq && new_seq != sequence
            sequence = new_seq
            parent_question = Question.create!(display: parent_display)
            puts "Adding parent question parent_display: #{parent_display}, id: #{parent_question.id}"
            parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder)
            puts "Adding parent question parent_game_question: #{parent_display}, id: #{parent_game_question.id}"
          else
            parent_question = check_gameholder_question(game_holder, parent_display)
            puts "Using parent question parent_display: #{parent_display}, id: #{parent_question.id}"
            if !parent_question
              parent_question = Question.create!(display: parent_display)
              puts "Adding parent question parent_display: #{parent_display}, id: #{parent_question.id}"
              parent_game_question = GameQuestion.create!(question: parent_question, game_holder: game_holder)
              puts "Adding parent question parent_game_question: #{parent_display}, id: #{parent_game_question.id}"
            end
          end

          if parent_question
            parent_game_question = GameQuestion.where(question: parent_question, game_holder: game_holder).first
            question = Question.create!(display: display, solution: solution, parent_question: parent_question)
            puts "Adding question display: #{display} , solution: #{solution}"
            game_question = GameQuestion.create!(question: question, parent_question: parent_game_question)
            
            option_start = 7
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
                puts "Adding option_#{(option_count+1)} display: #{display}, hint: #{hint}, title: #{title}, value_type: #{value_type}"
                game_option = GameOption.create!(option: option, game_question: game_question)
              end
            end
          end
        end
      end
      
    end
    break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
  end
end

def check_gameholder_question game_holder, display
  game_holder.game_questions.each do |g_q|
    return g_q.question if g_q.question.display == display
  end
  return nil
end

# PG: SCQ
def upload_tipping_data(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.include? ("for") )

      if row.cells[0] && row.cells[1] && row.cells[2]
        practice_type_name = row.cells[2].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[0].value
        game_holder_slug = row.cells[1].value

        practice_type = PracticeType.find_by(:slug => practice_type_slug)
        game_holder = GameHolder.find_by(:slug => game_holder_slug)

        if practice_type && game_holder
          display = row.cells[3].value
          tip = row.cells[4].value
          hint = row.cells[5]? row.cells[5].value : nil
          title = row.cells[6].value
          solution = row.cells[7]? row.cells[7].value : nil

          question = Question.create!(display: display, tip: tip, hint: hint, title: title, solution: solution)
          puts "Adding question display: #{display} , tip: #{tip}, hint: #{hint}, title: #{title}, solution: #{solution}"
          game_question = GameQuestion.create!(question: question, game_holder: game_holder)

          option_start = 8
          option_width = 2
          option_count = 9
          (0..(option_count-1)).each do |counter|
            display_index = option_start + (counter*option_width)
            correct_index = option_start + (counter*option_width) +  1

            if  row.cells[display_index] && row.cells[display_index].value
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
end

def change_game_holder_enabled_status(enabled)
  GameHolder.joins(:game_questions).group('game_holders.id').each do |g_h|
    g_h.update_attributes!(enabled: enabled)
    puts "Enabling GameHolder: #{g_h.name}" 
  end
end

def set_game_holder_title
  GameHolder.all.each do |g_h|
    g_h.update_attributes!(title: "#{g_h.game.name} GameHolder")
    puts "Setting title of GameHolder: #{g_h.name}" 
  end
end

def update_question_text
  Question.all.each do |question|
    replace_question_slash(question)
  end
end

def update_option_text
  Option.all.each do |op|
    replace_option_slash(op)
  end
end

def replace_question_slash(q)
  q.display = replace_slash(q.display)
  q.hint = replace_slash(q.hint)
  q.tip = replace_slash(q.tip)
  q.solution = replace_slash(q.solution)
  q.title = replace_slash(q.title)
  q.save!
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
    return text.gsub(/\\\\/, '\\')
  end
  return nil
end


game_start = 5
remove_game_question_references
remove_game_holder_references
upload_basic_acad_entity(book, 0)
upload_practice_types(book, 3)
set_acad_entity_enabled(true)
upload_scq_data(book, game_start)
upload_scq_data(book, game_start + 1)
upload_conversion_data(book, game_start + 2)
upload_diction_data(book, game_start + 3)
upload_discounting_data(book, game_start + 4)
upload_division_data(book, game_start + 5)
# upload_estimation_data(book, game_start + 6)
upload_inversion_data(book, game_start + 7)
upload_percentage_data(book, game_start + 8)
upload_proportion_data(book, game_start + 9)
upload_tipping_data(book, game_start + 11)
change_game_holder_enabled_status(true)
set_game_holder_title
update_question_text
update_option_text