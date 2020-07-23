class CharacterDialog < ApplicationRecord
  belongs_to :character_discussion
  belongs_to :character
  belongs_to :left_weapon, class_name: "Weapon", optional: true
  belongs_to :right_weapon, class_name: "Weapon", optional: true
  enum position: [ :left, :right, :center]
  enum animation: [ :walk_in, :walk_out, :talk, :strike]
  enum repeat_mode: [ :never, :once, :infinite]
  def self.get_default
    return CharacterDialog.last if CharacterDialog.all.count > 0
    character_dialog = CharacterDialog.new(character_discussion: CharacterDiscussion.get_default, 
      character: Character.get_default,
      left_weapon: Weapon.get_default,
      right_weapon: Weapon.get_default,
      )
    return character_dialog if character_dialog.save!
  end

  def self.default_audio_map
    {
      "Yes Guru Drona, I am ready for my next challenge": "d1",
      "Thank you Guru Drona": "d2",
      "Sure, Guru Drona. I will replay this game and practice more.": "d3",
      "Nicely Done Arjun!": "d4",
      "You have learnt the skill but you did not keep the momentum. You need to practice more until you perfect this skill.": "d5",
      "I am ready for the challenge.": "d6",
      "I will not disappoint you Guru Drona again!": "d7",
      "That was not a good performance. You need to practice lot more by retrying this challenge again and again.": "d8",
      "Time for a competition between your brothers and cousins.": "d9",
      "That was a wonderful performance": "d10",
      "Thank you Guru Drona! I want to see your ranking among all your brothers and cousins.": "d11",
      "You practised well but when you competed against your brothers, you lost the challenge!": "d12",
      "Pressure of competing with my brothers took a toll on me.": "d13",
      "Go son, practice more and more until you are ready for the ultimate challenge of competing with your brothers.": "d14",
      "Sure, Guru Drona": "d15"
    }
  end

  # def audio_url
  #   audio_url = CharacterDialog.default_audio_map[comment]
  #   return audio_url if !audio_url.nil?

  # end

  def right_weapon_colours
    return [] if right_weapon_colour.nil?
    return right_weapon_colour.split(';')
  end

  def left_weapon_colours
    return [] if left_weapon_colour.nil?
    return left_weapon_colour.split(';')
  end

  def helmet_colours
    return [] if helmet_colour.nil?
    return helmet_colour.split(';')
  end

  def armor_colours
    return [] if armor_colour.nil?
    return armor_colour.split(';')
  end

  def cape_colours
    return [] if cape_colour.nil?
    return cape_colour.split(';')
  end

  def pants_colours
    return [] if pants_colour.nil?
    return pants_colour.split(';')
  end

  def gloves_colours
    return [] if gloves_colour.nil?
    return gloves_colour.split(';')
  end

  def boots_colours
    return [] if boots_colour.nil?
    return boots_colour.split(';')
  end

  def prefix_url
    return nil if audio_url.nil?
    return audio_url.chomp(".mp3")
  end
end
