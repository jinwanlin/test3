# encoding: utf-8
class PaymentsController < ApplicationController
  load_and_authorize_resource class: 'Payment'
  
  def index
    @payments = current_user.payments
  end


  
end
