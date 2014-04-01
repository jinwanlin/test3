# encoding: utf-8
class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :payer #付款客户
      t.references :operator #操作者
      t.float :amount, :null => false, :default => 0.0 #交易金额
      t.float :overage, :null => false, :default => 0.0 #余额
      t.references :order 
      t.string :state

      t.timestamps
    end
  end
end
