class CharacterDiscussion < ApplicationRecord
  has_many :character_dialogs
  def self.get_default
    return CharacterDiscussion.last if CharacterDiscussion.all.count > 0
    character_discussion = CharacterDiscussion.new(name: "Default CharacterDiscussion", slug: "default-character-discussion-1")
    return character_discussion if character_discussion.save!
  end
end
