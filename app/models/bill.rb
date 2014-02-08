class Bill < ActiveRecord::Base
  attr_accessible :amount, :operator, :payer
end
