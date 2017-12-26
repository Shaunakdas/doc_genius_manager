class DropTimeTakenInSessionScores < ActiveRecord::Migration[5.1]
  def change
    remove_column :session_scores, :time_taken
  end
end
