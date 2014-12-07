class MarketController < ApplicationController
    def index
        # render :text=>"ok"
        redirect_to "/market_index.html"
    end
end
