class CreateMarkerGaps < ActiveRecord::Migration[5.1]
  def change
    create_table :marker_gaps do |t|
      t.integer :big
      t.integer :small
      t.integer :tiny

      t.timestamps
    end
  end
end
