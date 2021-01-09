class AddGameHolderToExternalQuizSource < ActiveRecord::Migration[5.1]
  def change
    add_reference :external_quiz_sources, :game_holder, foreign_key: true
  end
end
