module Api::V1
  class CharacterDialogSerializer < ActiveModel::Serializer
    attributes :id, :character, :left_weapon_colours, :right_weapon,
      :right_weapon_colours, :helmet, :armor, :cape, :pants, :gloves, :boots, :count,
      :comment, :comment_time,  :position, :animation, :repeat_mode, :sequence, :audio_url, :image_url
    has_one :left_weapon, serializer: WeaponSerializer
    has_one :right_weapon, serializer: WeaponSerializer
    has_one :character, serializer: CharacterSerializer
    def comment_time
      return object.comment.split(/\s+/).length/2 if !object.comment.nil?
    end

    def helmet
      {
        name: object.helmet_name,
        colours: object.helmet_colours
      }
    end

    def armor
      {
        name: object.armor_name,
        colours: object.armor_colours
      }
    end

    def cape
      {
        name: object.cape_name,
        colours: object.cape_colours
      }
    end

    def pants
      {
        name: object.pants_name,
        colours: object.pants_colours
      }
    end

    def gloves
      {
        name: object.gloves_name,
        colours: object.gloves_colours
      }
    end

    def boots
      {
        name: object.boots_name,
        colours: object.boots_colours
      }
    end
  end
end
