class AddTimeTakenToSessionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :session_scores, :time_taken, :integer
  end
end
