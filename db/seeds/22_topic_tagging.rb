require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/TopicTagging.xlsx')

def get_val cell
  return (cell.nil? ? nil : cell.value)
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
def upload_basic_acad_entity(book, count, start, finish)
  master_sheet = book[count]
  master_sheet.each_with_index do |row,i|

    next if i < start
    if row.cells[0]  && row.cells[0].value

      standard_name = (row.cells[0].value[1..-1].to_s).to_i.to_s
      standard_slug = standard_name

      subject_name = get_val(row.cells[1])
      subject_slug = get_val(row.cells[2])

      stream_name = get_val(row.cells[3])
      stream_slug = get_val(row.cells[4])

      chapter_name = get_val(row.cells[5])
      chapter_slug = get_val(row.cells[6])

      if row.cells[8]
        topic_name = get_val(row.cells[7])
        topic_slug = get_val(row.cells[8])
      end

      if row.cells[10]
        sub_topic_name = get_val(row.cells[9])
        sub_topic_slug = get_val(row.cells[10])
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

      if stream_slug.to_s == ""
        stream_name = subject_name
        stream_slug = subject_slug
      end

      #Create or find stream
      stream = Stream.find_by(:slug => stream_slug)
      if stream.nil? && stream_name
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

      if !topic_name
        topic_name = chapter_name
        topic_slug = chapter_slug
      end

      #Create or find topic
      if (not topic = Topic.find_by(:slug => topic_slug)) && topic_name.to_s != ""  && chapter
        puts "Adding topic #{topic_name}, slug: #{topic_slug}"
        topic = Topic.create!(:name => topic_name, :slug => topic_slug, :chapter => chapter,
          :sequence => chapter.topics.length+1)
      end

      #Create or find sub_topic
      if (not sub_topic = SubTopic.find_by(:slug => sub_topic_slug)) && (sub_topic_slug.to_s != "") && topic
        puts "Adding sub_topic #{sub_topic_name}, slug: #{sub_topic_slug}"
        sub_topic = SubTopic.create!(:name => sub_topic_name, :slug => sub_topic_slug, :topic => topic,
          :sequence => topic.sub_topics.length+1)
      end

      # internal_index = 11
      # while (get_val(row.cells[external_index])) do 
      #   external_quiz_link = get_val(row.cells[external_index])
      #   external_quiz_source = ExternalQuizSource.where(source_url: external_quiz_link).first
      #   puts "Adding QuizSource: #{external_quiz_source.to_json} with Topic: #{topic.to_json}"
      #   external_quiz_source.game_holder.update_attributes!(acad_entity: topic) if topic && external_quiz_source
      #   external_index = external_index + 1
      # end

      internal_index = 16
      while (get_val(row.cells[internal_index])) do 
        game_holder_slug = get_val(row.cells[internal_index])

        if (not game_holder = GameHolder.find_by(:slug => game_holder_slug)) && topic 
          puts "Tagging slug: #{game_holder_slug}, Topic: #{topic.slug}"
          game_holder = GameHolder.create!(:slug => game_holder_slug, acad_entity: topic)
        elsif !game_holder.nil?
          puts "Updating game_holder #{game_holder_name} , slug: #{game_holder_slug}, Topic: #{topic.slug}"
          game_holder.update_attributes!(acad_entity: topic)
        end
        internal_index = internal_index + 1
      end
    end
    break if i == finish
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

def set_game_holder_title(book, count, start, finish)
  master_sheet = book[count]
  master_sheet.each_with_index do |row,i|

    next if i < start
    if row.cells[0]  && row.cells[0].value

      game_holder_slug = get_val(row.cells[0])
      game_holder_title = get_val(row.cells[1])

      break if game_holder_slug.nil? && game_holder_title.nil?

      if game_holder = GameHolder.find_by(:slug => game_holder_slug)
        puts "Adding title for slug: #{game_holder_slug}, Title: #{game_holder_title}"
        game_holder.update_attributes!(title: game_holder_title)
      end
    end
    break if i == finish
  end
end


# Maths
# upload_basic_acad_entity(book, 0, 2, 10) 
# English
# upload_basic_acad_entity(book, 1, 2, 187)
# Science
# upload_basic_acad_entity(book, 2, 2, 572)
# Internal GameHolder Title
# set_game_holder_title(book, 3, 1, 4) #406
# upload_practice_types(book, 3)
# upload_game_holder_details(book, 3)
# set_acad_entity_enabled(true)

