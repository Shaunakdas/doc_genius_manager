module Api::V1
  class CharacterDialogSerializer < ActiveModel::Serializer
    attributes :id, :character, :left_weapon_colour, :right_weapon,
      :right_weapon_colour, :count, :comment,  :position, :animation, :repeat_mode, :sequence 
    has_one :left_weapon, serializer: WeaponSerializer
    has_one :right_weapon, serializer: WeaponSerializer
    has_one :character, serializer: CharacterSerializer
  end
end
