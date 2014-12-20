class InvoiceController < ApplicationController
    

    
    def check_session(forceLogin = false)
        if forceLogin == true || session["slcookie"]  == nil
           cookie = sl_login
           if cookie == nil
               error("login failed")
               return
           end
           session["slcookie"] = cookie 
        end
        return true
    end
    
    def SL_get(path, headers=nil)
        h = headers.merge({"Cookie"=>session["slcookie"]})
        sl_get( path, nil, headers)
    end
    def SL_post(path, data=nil, headers=nil)
        h = headers.merge({"Cookie"=>session["slcookie"]})
        sl_post(path, data, headers)
    end       
    def list
        return if !check_session(true)
       
        resp, data = SL_get("/Invoices", {
           "Prefer"=>"odata.maxpagesize=1",
           })
        
        if resp.class == Net::HTTPUnauthorized
            check_session(true)
        end
        
        p data
        render :text=>"OK" 
    end
end
