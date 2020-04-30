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
end
