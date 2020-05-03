class CharacterDiscussion < ApplicationRecord
  has_many :character_dialogs, -> { order('sequence asc') }
  enum stage: [ :introduction, :success, :failure]
  def self.get_default
    return CharacterDiscussion.last if CharacterDiscussion.all.count > 0
    character_discussion = CharacterDiscussion.new(name: "Default CharacterDiscussion", slug: "default-character-discussion-1")
    return character_discussion if character_discussion.save!
  end

  def update_dialog_weapon character_slug, weapon, weapon_colour, left_flag
    character = Character.find_by(slug: character_slug)
    return nil if character.nil?
    character_dialogs.where(character: character).each do |dialog|
      puts "Updating character discussion. Name: #{name},stage: #{stage}. Weapon: #{weapon.name}"
      dialog.update_attributes!(left_weapon: weapon, left_weapon_colour: weapon_colour) if left_flag
      dialog.update_attributes!(right_weapon: weapon, right_weapon_colour: weapon_colour) if !left_flag
    end
  end
end
