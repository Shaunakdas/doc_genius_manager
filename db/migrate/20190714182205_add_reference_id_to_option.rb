class AddReferenceIdToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :reference_id, :int
    add_column :options, :positive, :bool
  end
end
