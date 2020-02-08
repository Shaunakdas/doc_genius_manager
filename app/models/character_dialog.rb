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
end
