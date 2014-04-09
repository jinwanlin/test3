class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.float :jindu
      t.float :weidu
      t.string :state
      t.string :address

      t.timestamps
    end
  end
end
