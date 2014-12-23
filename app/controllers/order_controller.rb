class OrderController < ApplicationController
    def list
        @list = Invoice.list("order")
    end
    
    def show
        @item = Invoice.get("order", params[:id])        
    end
end
