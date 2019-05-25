class AddMarkerGapToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :marker_gap, foreign_key: true, null: true
  end
end
