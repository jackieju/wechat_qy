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

def sl_login
    resp, data = sl_post("/Login", "{\"UserName\": \"manager\", \"Password\": \"manager\", \"CompanyDB\": \"SBODEMOUS\"}")
    p "resp=>#{resp}, data=>#{data}"
    cookie = nil
    if resp.code == 200
        cookie = resp["set-cookie"]
    end
    return cookie
end

def sl_get(path, data=nil, headers=nil)
    url = "https://54.227.44.220:50000/b1s/v1#{path}"
    resp, data = http_get(url, data, 50000, headers)
    
    p "resp=>#{resp.class.instance_methods.inspect}"
    p "data=>#{data}"
    
    return resp, data
end
def sl_post(path, data=nil, headers=nil)
    url = "https://54.227.44.220:50000/b1s/v1#{path}"
        resp, data = https_post(url, data, 50000, headers)

    p "resp=>#{resp.class.instance_methods.inspect}"
    p "data=>#{data}"
    
    return resp, data
end