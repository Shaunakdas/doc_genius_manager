class AddCommentToCharacterDialog < ActiveRecord::Migration[5.1]
  def change
    add_column :character_dialogs, :comment, :string
  end
end
