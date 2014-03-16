class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.references :user
      t.string :keywords
      t.string :has_result
      t.timestamps
    end
    add_index :search_histories, :user_id
  end
end
