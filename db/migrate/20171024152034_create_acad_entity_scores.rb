class CreateAcadEntityScores < ActiveRecord::Migration[5.1]
  def change
    create_table :acad_entity_scores do |t|
      t.decimal :average
      t.decimal :maximum
      t.decimal :last
      t.time :time_spent
      t.integer :passed_count
      t.integer :failed_count
      t.integer :seen_count
      t.decimal :percentile
      t.references :acad_entity, polymorphic: true
      t.references :session_score, foreign_key: true

      t.timestamps
    end
  end
end
