class ChangeVerificationDefaultTrueInUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :verification_code, false
  end
end
