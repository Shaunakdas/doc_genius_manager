class AddStageToCharacterDiscussion < ActiveRecord::Migration[5.1]
  def change
    add_column :character_discussions, :stage, :integer
  end
end
