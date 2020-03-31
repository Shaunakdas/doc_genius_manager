class AddPostSubmitTextToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :post_submit_text, :string
  end
end
