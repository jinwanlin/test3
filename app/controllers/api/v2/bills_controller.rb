module Api
  module V2
    class BillsController < Api::BaseController
      def index
        @bills = Bills.where()
      end
      
      
    end
  end
end