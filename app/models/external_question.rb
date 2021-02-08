class ExternalQuestion < ApplicationRecord
  belongs_to :external_quiz_source
  belongs_to :question, optional: true

  def move_asset_to_s3
    return nil if question_type != "Multiple Choice"
    return nil if image_url.nil? && audio_url.nil? && !joined_options.include?("quizizz.com")
    update_attributes!(s3_image_url: ExternalQuizSource.upload_to_s3(image_url),
    s3_audio_url: ExternalQuizSource.upload_to_s3(audio_url),
    s3_answer_url: move_options_image_to_s3)
    puts "Uploaded image to #{s3_image_url} and audio to #{s3_audio_url}"
    
  end

  def move_options_image_to_s3
    return nil if joined_options.nil?
    return nil if !joined_options.include?("quizizz.com")
    option_urls = []
    joined_options.split("\n---\n").each_with_index do |op,i|
      s3_url = ExternalQuizSource.upload_to_s3(op)
      puts "Options image #{s3_url}"
      option_urls << s3_url
    end
    return option_urls.join("\n---\n")
  end

  def create_question
    return nil if question_type != "Multiple Choice"
    if question
      ques = question
      gq = GameQuestion.where(question: question).first
    else 
      ques_params = {
        display: ques_display(display),
        time: time,
        image_url: s3_image_url,
        audio_url: s3_audio_url}
      puts "ExternalQuestion #{id}: Adding Question #{ques_params.to_json} from ExternalQuestion #{self.to_json}"
      ques = Question.create!(ques_params)
      update_attributes!(question: ques)
      gq = GameQuestion.create!(question: ques, game_holder: external_quiz_source.game_holder)
      if ((!s3_answer_url.nil?) && (s3_answer_url.include? ("\n---\n")))
        s3_answer_url.split("\n---\n").each {|x| x.slice!("\n---") }.each_with_index do |op,i|
          create_option(gq, nil,op,(i == correct_option))
        end
      else
        joined_options.split("\n---\n").each {|x| x.slice!("\n---") }.each_with_index do |op,i|
          create_option(gq, op,nil,(i == correct_option))
        end
      end
    end
    
  end

  def ques_display ques
    return ques[3..-1] if ques[0..2] == "Q. "
    return ques
  end

  def create_option game_question, display, image_url, correct
    op_params = {
      display: display,
      image_url: image_url,
      correct: correct
    }
    puts "ExternalQuestion #{id}: Adding Option #{op_params.to_json} "
    option = Option.create!(op_params)
    game_option = GameOption.create!(game_question: game_question, option: option)
  end
end
