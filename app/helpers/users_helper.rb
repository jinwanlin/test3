# encoding: utf-8
module UsersHelper
  
  def phone_no phone
    phone.insert(3, '-').insert(8, '-') if phone.length == 11
  end
end
