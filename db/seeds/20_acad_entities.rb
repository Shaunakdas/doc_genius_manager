require 'rubyXL'
# require 'html_press'
# require 'nokogiri'

# book = RubyXL::Parser.parse('db/seeds/excels/WorkingRules_Shaunak_v0.14.xlsx')
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

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
        puts chapter.to_json
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
          solution = row.cells[4].value

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

            if row.cells[upper_index]
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
master_sheet = book[6]

# PG: Discounting
master_sheet = book[7]

# PG: Division
master_sheet = book[8]

# PG: Inversion
master_sheet = book[9]

# PG: Percentages
master_sheet = book[10]

# PG: Proportion
master_sheet = book[11]

# PG: Tipping
master_sheet = book[12]





# upload_basic_acad_entity(book, 0)
# upload_practice_types(book, 3)
# set_acad_entity_enabled(true)
# upload_scq_data(book, 4)
upload_conversion_data(book, 5)