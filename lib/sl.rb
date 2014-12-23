# def sl_login
#     resp, data = https_post("https://54.227.44.220:50000/b1s/v1/Login", "{\"UserName\": \"manager\", \"Password\": \"manager\", \"CompanyDB\": \"SBODEMOUS\"}", 50000)
#     p "resp=>#{resp.class.instance_methods.inspect}"
#     p "data=>#{data}"
#     cookie = nil
#     if resp.class == Net::HTTPOK
#         cookie = resp["set-cookie"]
#     end
#     return cookie
# end
# def sl_login
#     resp, data = sl_request("post", "/Login", "{\"UserName\": \"manager\", \"Password\": \"manager\", \"CompanyDB\": \"SBODEMOUS\"}")
#     p "resp=>#{resp}, data=>#{data}"
#     cookie = nil
#     if resp.code == 200
#         cookie = resp["set-cookie"]
#     end
#     return cookie
# end
class SL
    
    @@service_url="https://54.227.44.220:50000/b1s/v1"
    @@service_port = 50000
    @@cookie = nil
    def self.login
        resp, data = https_post("#{@@service_url}/Login", "{\"UserName\": \"manager\", \"Password\": \"manager\", \"CompanyDB\": \"SBODEMOUS\"}", @@service_port)
        p "resp=>#{resp.code.class}, data=>#{data}"
         p "set-cookie=>#{resp["set-cookie"]}"
        # cookie = nil
        if resp.code == "200"
            @@cookie = resp["set-cookie"]
        end
        return @@cookie
    end

    def self.isLogin?
        p "@@cookie=#{@@cookie}"
        return @@cookie!=nil
    end
    def self.cookie
         @@cookie
    end
    def self.get(path, headers=nil)
        if !headers || !headers["Cookie"]
            login if !isLogin?  
            headers = {} if !headers
            
            headers["Cookie"] = cookie
        end
        
        
        url = "#{@@service_url}#{path}"
        resp, data = http_get(url, nil,  @@service_port, headers)
    
        # p "resp=>#{resp.class.instance_methods.inspect}"
        p "data=>#{data}"
    
        return resp, data
    end
    def self.post(path, data=nil, headers=nil)
        if !headers || !headers["Cookie"]
            login if !isLogin?  
            headers = {} if !headers
            headers["Cookie"] = cookie
        end
        
        url = "#{@@service_url}#{path}"
        resp, data = https_post(url, data,  @@service_port, headers)

        # p "resp=>#{resp.class.instance_methods.inspect}"
        p "data=>#{data}"
    
        return resp, data
    end
end