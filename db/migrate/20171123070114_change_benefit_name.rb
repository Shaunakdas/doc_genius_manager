class ChangeBenefitName < ActiveRecord::Migration[5.1]
  def change
    rename_table :benefits, :benifits
  end
end
