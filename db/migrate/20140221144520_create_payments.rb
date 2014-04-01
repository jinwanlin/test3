class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :payer #付款方
      t.references :operator #收款人
      t.float :amount, :null => false, :default => 0.0 #交易金额
      t.float :overage, :null => false, :default => 0.0 #余额
      t.text :desc #备注
      t.references :order
      t.string :type

      t.timestamps
    end
    add_index :payments, :payer_id
    add_index :payments, :operator_id
  end
end


