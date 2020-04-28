module Api::V1
  class CharacterDialogSerializer < ActiveModel::Serializer
    attributes :id, :character, :left_weapon_colours, :right_weapon,
      :right_weapon_colours, :count, :comment, :comment_time,  :position, :animation, :repeat_mode, :sequence 
    has_one :left_weapon, serializer: WeaponSerializer
    has_one :right_weapon, serializer: WeaponSerializer
    has_one :character, serializer: CharacterSerializer
    def comment_time
      return object.comment.split(/\s+/).length/2 if !object.comment.nil?
    end

    def right_weapon_colours
      return [] if object.right_weapon_colour.nil?
      return object.right_weapon_colour.split(';')
    end

    def left_weapon_colours
      return [] if object.left_weapon_colour.nil?
      return object.left_weapon_colour.split(';')
    end
  end
end
