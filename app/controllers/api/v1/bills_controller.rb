module Api
  module V1
    class BillsController < Api::BaseController
      def index
        @bills = Bills.where()
      end
    end
  end
  
  
end