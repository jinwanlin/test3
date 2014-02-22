class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :payer #付款方
      t.references :operator #收款人
      t.float :amount #交易金额
      t.float :overage #余额
      t.text :desc
      t.references :order

      t.timestamps
    end
    add_index :payments, :payer_id
    add_index :payments, :operator_id
    add_index :payments, :order_id
  end
end
