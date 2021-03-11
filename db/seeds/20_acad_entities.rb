require 'rubyXL'
# require 'html_press'
# require 'nokogiri'

# book = RubyXL::Parser.parse('db/seeds/excels/WorkingRules_Shaunak_v0.14.xlsx')
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def update_standard_sequence
  Standard.all.each do |std|
    std.update_attributes!(sequence: std.slug.to_i)
  end
end

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

      chapter_slug = row.cells[9].value

      topic_name = row.cells[12].value
      topic_slug = row.cells[13].value

      if row.cells[16] && row.cells[16].value
        practice_type_name = row.cells[16].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[21].value
        game_holder_slug = row.cells[22].value
      end

      topic = Topic.find_by(:slug => topic_slug)
      if topic.nil?
        chapter = Chapter.find_by(:slug => chapter_slug)
        puts "Adding topic #{topic_name}, slug: #{topic_slug}"
        topic = Topic.create!(:name => topic_name, :slug => topic_slug, :chapter => chapter,
          :sequence => chapter.topics.length+1)
      end

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


# # GameHolder Details
def upload_game_holder_details(book, count)
  master_sheet = book[count]
  master_sheet.each do |row|
    if row.cells[0]  && row.cells[0].value  && (['C06','C07'].include?row.cells[0].value ) && row.cells[1].value == 'Maths'

      if row.cells[16] && row.cells[16].value
        practice_type_name = row.cells[16].value
        practice_type_slug = practice_type_name.downcase
        game_holder_name = row.cells[21].value
        game_holder_slug = row.cells[22].value
        game_holder_sequence = row.cells[19].value
        game_holder_title = row.cells[23].value
      end

      game_holder = GameHolder.find_by(:slug => game_holder_slug)

      if game_holder && game_holder_sequence && game_holder_title
        game_holder.update_attributes!(title: game_holder_title, sequence: game_holder_sequence)
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


# game_start = 5
# upload_basic_acad_entity(book, 0)
# upload_practice_types(book, 3)
# upload_game_holder_details(book, 3)
# set_acad_entity_enabled(true)

