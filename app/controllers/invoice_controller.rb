class InvoiceController < ApplicationController
    

    
    # def check_session(forceLogin = false)
    #     if forceLogin == true || session["slcookie"]  == nil
    #        cookie = sl_login
    #        p "cookie:#{cookie}"
    #        if cookie == nil
    #            error("login failed")
    #            return false
    #        end
    #        session["slcookie"] = cookie 
    #     end
    #     $slcookie =  session["slcookie"]
    #     return true
    # end
    
    # def SL_get(path, headers=nil)
    #     h = headers.merge({"Cookie"=>session["slcookie"]})
    #     sl_get( path, nil, h)
    # end
    # def SL_post(path, data=nil, headers=nil)
    #     h = headers.merge({"Cookie"=>session["slcookie"]})
    #     sl_post(path, data, headers)
    # end       
    def list
        # return if !check_session()
        
        @list = Invoice.list("invoice")
        # resp, data = SL_get("/Invoices", {
        #    "Prefer"=>"odata.maxpagesize=1",
        #    })
        # 
        # if resp.class == Net::HTTPUnauthorized
        #     check_session(true)
        # end
        
        # p data
        # render :text=>"OK" 
    end
    
    def show
        @item = Invoice.get("invoice", params[:id])
        # p "item:#{@item.inspect}"
        p "docnum #{@item[:DocNum]}"
    end
end
