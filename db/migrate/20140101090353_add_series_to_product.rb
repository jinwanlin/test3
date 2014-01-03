class AddSeriesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :series, :integer # 分组，用于作涨价先后次序
  end
end
