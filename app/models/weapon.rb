class Weapon < ApplicationRecord
  def self.get_default
    return Weapon.last if Weapon.all.count > 0
    weapon = Weapon.new(name: "Default Weapon", slug: "default-weapon-1")
    return weapon if weapon.save!
  end
end
