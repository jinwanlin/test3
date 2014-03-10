class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.has_attached_file :source
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
