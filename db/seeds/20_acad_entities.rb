require 'rubyXL'
# require 'html_press'
# require 'nokogiri'

book = RubyXL::Parser.parse('db/seeds/excels/WorkingRules_Shaunak_v0.13.xlsx')
master_sheet = book[0]

count = 0
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

    #Create or find stream
    if not standard = Standard.find_by(:slug => standard_slug)
      puts "Adding Standard #{standard_name}"
      standard = Standard.create(:name => standard_name, :slug => standard_slug)
    end

    #Create or find stream
    if not subject = Subject.find_by(:slug => subject_slug)
      puts "Adding Subject #{subject_name}"
      subject = Subject.create(:name => subject_name, :slug => subject_slug)
    end

    #Create or find stream
    if not stream = Stream.find_by(:slug => stream_slug)
      puts "Adding stream #{stream_name}"
      stream = Stream.create(:name => stream_name, :slug => stream_slug, :subject => subject)
    end

    #Create or find chapter
    if (not chapter = Chapter.find_by(:slug => chapter_slug)) && chapter_name
      puts "Adding chapter #{chapter_name}"
      chapter = Chapter.create(:name => chapter_name, :slug => chapter_slug,
       :stream => stream, :standard => standard)
    end

    #Create or find topic
    if (not topic = Topic.find_by(:slug => topic_slug)) && topic_name
      puts "Adding topic #{topic_name}, slug: #{topic_slug}"
      topic = Topic.create(:name => topic_name, :slug => topic_slug, :chapter => chapter)
    end

    #Create or find sub_topic
    if (not sub_topic = SubTopic.find_by(:slug => sub_topic_slug)) && sub_topic_name
      puts "Adding sub_topic #{sub_topic_name}, slug: #{sub_topic_slug}"
      sub_topic = SubTopic.create(:name => sub_topic_name, :slug => sub_topic_slug, :topic => topic)
    end

    #Create or find question_type 
    if (not question_type = QuestionType.find_by(:slug => question_type_slug)) && question_type_name && (question_type_name.length > 3)
      puts "Adding question_type #{question_type_name} , slug: #{question_type_slug}"
      question_type = QuestionType.create(:name => question_type_name, :slug => question_type_slug, :sub_topic => sub_topic)
    end

  end
  break if row.cells[0] && row.cells[0].value && (row.cells[0].value[0] == 'End')
end