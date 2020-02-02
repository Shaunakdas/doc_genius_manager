class Character < ApplicationRecord
  def self.get_default
    return Character.last if Character.all.count > 0
    character = Character.new(name: "Default Character", slug: "default-character-1")
    return character if character.save!
  end
end
