module Api::V1
  class CharacterDiscussionSerializer < ActiveModel::Serializer
    attributes :id, :name, :display_style
    has_many :character_dialogs, serializer: CharacterDialogSerializer
    def character_dialogs
      return object.character_dialogs if object.character_dialogs.count > 0
      [CharacterDialog.get_default]
    end

    def display_style
      return "text" if object.id%2 == 0
      return "no_text" if object.id%2 == 1
    end
  end
end
