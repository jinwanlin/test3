class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.user, :payer #付款客户
      t.user, :operator #操作者
      t.float :amount #交易金额
      t.float :overage #余额
      t.order, :order 
      t.string, :state

      t.timestamps
    end
  end
end
