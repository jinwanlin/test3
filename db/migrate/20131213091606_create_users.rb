# encoding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :password
      t.string :county # 区
      t.string :towns # 乡镇（上地、西二旗、常营等）
      t.string :street # 街道
      t.string :house # 小区、门牌号
      t.float :latitude # 纬度
      t.float :longitude # 经度
      t.string :state
      t.string :validate_code # 校验码
      t.string :token
      t.integer :level, :default => 1
      t.string :role
      t.string :baidu_user_id
      t.text :desc
      
      t.timestamps
    end
  end
end