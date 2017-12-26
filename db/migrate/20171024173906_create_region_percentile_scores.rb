class CreateRegionPercentileScores < ActiveRecord::Migration[5.1]
  def change
    create_table :region_percentile_scores do |t|
      t.integer :percentile_count
      t.decimal :score
      t.references :acad_entity, polymorphic: true, index: {:name => "index_region_percentile_scores_on_acad_entity"} 
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
