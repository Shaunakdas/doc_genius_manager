module Api::V1
  class CharacterDiscussionSerializer < ActiveModel::Serializer
    attributes :id, :name
    has_many :character_dialogs, serializer: CharacterDialogSerializer
    def character_dialogs
      [CharacterDialog.get_default]
    end
  end
end
