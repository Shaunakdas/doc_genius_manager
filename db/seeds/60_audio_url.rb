# print_folder_structure

# xargs -I {} mkdir -p "{}" < folder_structure.txt 

def delete_dialog_urls
  CharacterDialog.where.not(audio_url: nil).each do |dialog|
    dialog.update_attributes!(audio_url: nil)
  end
end

# https://s3.ap-south-1.amazonaws.com/drona-player.docgenius.in/s3_audios/1_c/hhf_l/d/i/1.mp3
s3_prefix = "https://s3.ap-south-1.amazonaws.com/drona-player.docgenius.in/s3_audios/"
def get_enabled_level_map s3_prefix
  level_map = {}
  Standard.first.chapters.where(enabled: true).each do |chap|
    level_map = get_chapter_level_maps(chap, s3_prefix, level_map)
  end
  return level_map
end

def get_chapter_level_maps chapter, s3_prefix, level_map
  current_prefix = s3_prefix + "#{chapter.s3_slug}/"
  chapter.topics.where(enabled: true).each do |topic|
    topic.practice_game_levels.each do |level|
      current_prefix += "#{level.s3_slug}/"
      level_map[level.id.to_s] = current_prefix
      # Level Asset Urls is over
      current_prefix = current_prefix.chomp("#{level.s3_slug}/")
    end
  end
  return level_map
end

# Compulsory File urls and Prefix urls added
def set_necessary_level_urls s3_prefix
  puts "Adding Compulsory File urls and Prefix urls"
  default_audio_map = CharacterDialog.default_audio_map
  get_enabled_level_map(s3_prefix).each do |k,url|
    level = GameLevel.find(k)
    current_prefix = url
    level.all_character_discussions.each do |discuss|
      discuss.character_dialogs.where(animation: "talk").each_with_index do |dialog,i|
        next if dialog.comment.nil?
        audio_url = "#{current_prefix}d/#{discuss.stage.first}/#{i+1}.mp3"
        audio_url = "#{s3_prefix}def/#{default_audio_map[dialog.comment.to_sym]}.mp3" if default_audio_map.has_key?(dialog.comment.to_sym)
        dialog.update_attributes!(audio_url: audio_url)
        puts "Setting Level: #{level.title}, Discussion Stage: #{discuss.stage}, id: #{i+1}, audio_url: #{audio_url}"
      end
    end
    if level.practice_mode != "practice"
      level.game_questions.each do |gq|
        current_prefix += "#{gq.question.s3_slug}/"
        gq.question.update_attributes!(prefix_url: "#{current_prefix}")
        puts "Setting Level: #{level.title}, Question title: #{gq.question.display}, audio_prefix: #{current_prefix}"
      
        # If question's options has hints
        hint_options = gq.option_hint_list
        if hint_options.count > 0
          current_prefix += "options/"
          hint_options.each_with_index do |op,i|
            gq.game_options[i].option.update_attributes!(prefix_url: "#{current_prefix}#{op}_op/")
            puts "Setting Level: #{level.title}, Option Index: #{op}, audio_prefix: #{current_prefix}#{op}_op/"
          end
          current_prefix = current_prefix.chomp("options/")
        end
  
        # Question Asset Urls is over
        current_prefix  = current_prefix.chomp("#{gq.question.s3_slug}/")
      end
    end
  end
end

# Based on available files, add image and question audio
def get_file_list
  puts "Adding image and question audio, Based on available files"
  discussion_images = []
  question_audios = []
  question_hint_audios = []
  option_hint_audios = []
  level_map = {}
  chapter = nil
  File.readlines('folder_structure.txt').each do |line|
    location = line.split('./').last.chomp("\n")
    next if location.index("_c").nil?
    chap_id = location.split("_c/").first
    if !chapter.nil? && (chap_id.to_i != chapter.id)
      puts "Chapter #{chapter.id} finished"
      level_map = get_chapter_level_maps(chapter, "", level_map)
      set_links(level_map,discussion_images, question_audios, question_hint_audios, option_hint_audios)
      discussion_images = []
      question_audios = []
      question_hint_audios = []
      option_hint_audios = []
      level_map = {}
    end
    chapter = Chapter.find(chap_id)
    # Check for discussion images
    if (location.index("/d")) && (location.index(".png"))
      discussion_images << location
    elsif  (location.index("_o")) && (location.index(".mp3"))
      option_hint_audios << location
    elsif  (location.index("hint")) && (location.index(".mp3"))
      question_hint_audios << location
    elsif  (location.index("q.mp3"))
      question_audios << location
    end
  end
  puts "Chapter #{chapter.id} finished"
  set_links(level_map,discussion_images, question_audios, question_hint_audios, option_hint_audios)
end

def set_links(level_map,discussion_images, question_audios, question_hint_audios, option_hint_audios)
  # Discussion Images
  level_map.each do |k,url|
    level = GameLevel.find(k)
    set_level_discussion_image(level, discussion_images)

    # Question Audio
    if level.practice_mode != "practice"
      level.game_questions.each do |gq|
        set_question_audio(gq.question, question_audios)
      end
    end

  end

end

def set_level_discussion_image level, discussion_images
  level.all_character_discussions.each do |discuss|
    discuss.character_dialogs.where(animation: "talk").each_with_index do |dialog,i|
      next if dialog.prefix_url.nil?
      folder_url = dialog.prefix_url.split("s3_audios/").last
      image_url = "#{dialog.prefix_url}.png"
      image_url = nil if !discussion_images.include?("#{folder_url}.png")
      dialog.update_attributes!(image_url: image_url) 
      puts "Setting Level: #{level.title}, Discussion Stage: #{discuss.stage}, id: #{i+1}, image_url: #{image_url}"
    end
  end
end

def set_question_audio question, question_audios
  folder_url = question.prefix_url.split("s3_audios/").last
  audio_url = "#{question.prefix_url}q.mp3"
  audio_url = nil if !question_audios.include?("#{folder_url}q.mp3")
  question.update_attributes!(audio_url: audio_url) 
  puts "Setting Question title: #{question.display}, audio_url: #{audio_url}"
end


# delete_dialog_urls

# Compulsory File urls and Prefix urls added
# set_necessary_level_urls(s3_prefix)


# Based on available files, add image and question audio
# get_file_list