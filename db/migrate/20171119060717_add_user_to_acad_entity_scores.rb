class AddUserToAcadEntityScores < ActiveRecord::Migration[5.1]
  def change
    add_reference :acad_entity_scores, :user, foreign_key: true
  end
end
