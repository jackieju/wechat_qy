def generate_password(length=6)  
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ123456789'  
  password = ''  
  length.downto(1) { |i| password << chars[rand(chars.length - 1)] }  
  password  
end  
  
  
def i_to_ch(i)
    list = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
    s = i.to_s
    ret = ""
   
    for k in 0..s.size-1
        n = s[k]-48
          str=""
         if n == 0
             str = "零" if s.size>=3 && k!=s.size-1 && k!=0 # not first and last
         else
         
            d = list[n]
            l = s.size-k-1
            case l
            when 0: str=d
            when 1: 
                begin
                if n != 1
                    str += d
                end
                str +="十"
                end
            when 2: str += d+"百"
            when 3: str += d+"千"
            when 4: str += d+"万"
            when 5: str += d+"十万"
            when 6: str += d+"百万"
            when 7: str += d+"千万"
            when 8: str += d+"亿"
            when 9: str += d+"十亿"
            when 10: str += d+"百亿"
            when 11: str += d+"千亿"
            when 12: str += d+"万亿"
            end
        end
        if str[str.size-1..str.size-1] == '零' && str.size>1
            str = str[0..str.size-2]
        end
        ret += str
        
    end
    return ret
end

def rand_get_from_array(ar)
    return ar[rand(ar.size)]
end

def obj_is_number?(o)
    return o.is_a?(Numeric)
end
def str_is_number?(s)
    return s.to_i.to_s == s
end


def unrand(min, max, rate=2)
  s = max - min +1
  index = (rand(rate*s)+rand(rate*s))/rate
  index = s-1 if index == s
  index = s-index%s if index > s
  return index + min
end

=begin pastable code
begin
    raise Exception.new
rescue Exception=>e
    stack = 100
    if e.backtrace.size >=2 
        stack  += 1
        stack = e.backtrace.size-1 if stack >= e.backtrace.size
        p e.backtrace[1..stack].join("\n") 
    end
end
=end
def show_stack(stack = nil)
	stack = 99999 if stack == nil || stack <= 0
	begin
	    raise Exception.new
	rescue Exception=>e
	    if e.backtrace.size >=2 
	        stack  += 1
	        stack = e.backtrace.size-1 if stack >= e.backtrace.size
	        return e.backtrace[1..stack].join("\n") 
	    end
	end
	return ""
end
def util_get_prop(prop, k)
      js = prop
      if js.class == String
          js = JSON.parse(prop)
      end
      if js
          return js[k]
      else
          return nil
      end
end
def util_set_prop(prop,n,v)
      js = prop
      if js.class == String
          js = JSON.parse(prop)
      end
      if js == nil
          js =JSON.parse("{}")
      end

    js[n] = v
   return  js.to_json
end

# ==========================
#  File system
# ==========================
def append_file(fname, content)
     begin
         aFile = File.new(fname,"a")
         aFile.puts content
         aFile.close
     rescue Exception=>e
         # logger.error e
         p e.inspect
     end
end
def get_dir(path)
    if path.end_with?("/")
        return path[0..path.size-2]
    end
    index = path.rindex("/")
    if index == nil
        return path
    else
        return path[0..index-1]
    end
end
def save_to_file(data, fname)
    dir = get_dir(fname)
    FileUtils.makedirs(dir)
    begin
            open(fname, "w+") {|f|
                   f.write(data)
               }    
    rescue Exception=>e
         err e
         return false
    end
    return true
end
def append_to_file(data, fname)
    append(fname, data)
end
=begin
def test
  count = {}
  for a in 0..1000
    i = unrand(0, 10)
    if count[i] == nil
      count[i] = 0
    else
      count[i] += 1
    end
  end
  for a in 0..10
    p "#{a}:#{count[a]}"
  end
end
=end
# p i_to_ch(3)


# =============================
#    http utility
# =============================
# require 'net/https'
require 'net/http'
def hash_to_querystring(hash)
  if hash == nil or hash.empty?
    return ""
  end
  puts "==.>1"
  qs = hash.keys.inject('') {|query_string, key|
    v = hash[key]
    v = "" if v==nil
    query_string += '&' unless key == hash.keys.first
    query_string += "#{URI.encode(key.to_s)}=#{URI.encode(v)}"
    # p "inject1:"+query_string
    # query_string1
  }
  puts "inject2:#{qs}"
  
  return qs
end

=begin
def http_get(url, p, https=false, port=nil)
  uri = URI.parse(url)
  if port != nil
      _port = port
  elsif https == true
      _port = 443
  else
      _port = uri.port
  end
  http = Net::HTTP.new(uri.host, _port)
  http.use_ssl = true if https
  
  http.get(uri.path+"?"+hash_to_querystring(p), nil)
end 
=end
 def qs_to_hash(query)
     keyvals = query.split('&').inject({}) do |result, q|
     k,v = q.split('=')
     if !v.nil?
     result.merge({k => v})
     elsif !result.key?(k)
     result.merge({k => true})
     else
     result
     end
     end
     keyvals
 end

# def http_post(url, p)
#       p "==>url=#{url}"
# 
#     uri = URI.parse(url)
#     p "==>uri=#{uri.inspect}"
# 
#     data = Net::HTTP.post_form(uri, qs_to_hash(uri.query))
#     p "==>data:#{data.inspect}"
#     return data
# end
def https_post(url, p, port=nil, headers=nil)
    http_post(url, p, port, headers)
end

def http_request(url, method="get", hash=nil, _port=nil, headers=nil)
      p "==>url=#{url}, method=#{method}"

        p "headers1:#{headers.inspect}"

      uri = URI.parse(url)
      p "==>uri=#{uri.inspect}"
      bHttps = false
      bHttps = true if uri.scheme == "https"
      if _port
          port = _port
      else
          port = uri.port
          if !uri.port || uri.port == ""
              if bHttps
                  port = 443 
              else
                  port = 80 
              end
          end
      end
    # make sure your port is correct

#way 1
=begin
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(qs_to_hash(uri.query))
  p "==>#{qs_to_hash(uri.query).inspect}"
  p "===>host #{uri.host}, port #{_port}"
  https = Net::HTTP.new(uri.host, _port)
  https.use_ssl = true 
  res = https.start {|http| http.request(req) }
  puts "===>http code #{res.code}"
=end	   
#end way 1

    #way 2
      p "-->port:#{port}, host:#{uri.host}, scheme:#{uri.scheme}, quest:#{uri.query}, path:#{uri.path}"
         # p "->#{uri.path}?#{uri.query}"
         http = Net::HTTP.new(uri.host, port)
         http.read_timeout = 5000
         if bHttps
             http.use_ssl = true
             p "is Https, using ssl"
         end
         p '====>1'
         params = uri.query
         params = "" if !params
         p '====>2'

         # if headers
         #     headers.each{|k,v|
         #         http.head[k] = v
         #    }
         # end

         p "hash=#{hash}"
         if hash
             if (hash.class != String)
                   p "====>#{params.inspect}"
                 params += "&"+hash_to_querystring(hash)
                 post_data = params
                 p '====>31'
             else
                 post_data = hash
             end
         end

         p "post_data:#{post_data.inspect}"
         p "url: #{uri.inspect}"
         p "headers:#{headers.inspect}"

         if method.downcase=="post" 
             p "do post ..."
             resp, data = http.post(uri.path, post_data, headers)
         else
             p "do get ..."
             if post_data && post_data != ""
                 resp, data =  http.get(uri.path+"?"+post_data, headers)
             else
                 resp, data =  http.get(uri.path, headers)
             end
         end
         # resp, data = http.post2(uri.path, post_data, headers)
         p "resp=>#{resp.inspect}, header #{resp.header["set-cookie"]}"
    # end way 2

    	 return [resp, data]
end



# url:
# p: hash of parameters
def http_post(url, hash=nil, _port=nil, headers=nil)
 
    resp, data = http_request(url, "post", hash, _port, headers)
	return [resp, data]
end
def http_get(url, hash=nil, _port=nil, headers=nil)
 
    resp, data = http_request(url, "get", hash, _port, headers)
	return [resp, data]
end

def loadObject(path, p=nil, moduled=nil, base_path = nil)
       begin
           # p "require '"+ path+".rb'"
           if base_path 
               if !base_path.end_with?("/")
                   base_path = "#{base_path}/"
               end
               # eval "require '#{base_path}#{path}.rb'"      
           else
               # eval "require '"+ path+".rb'"      
           end

           b = path.split('/')
           if moduled != nil || moduled == true
               if moduled.class == String
                   name = b[b.size-1]
                   target_class = name.at(0).upcase+name.from(1)
                   target_class = "#{moduled}::#{target_class}"
               elsif moduled == true
                   target_class = "Game"
                   b.each{|r|
                       next if r == ""
                       # if target_class != ""
                           target_class += "::"
                       # end
                       target_class += r.at(0).upcase+r.from(1)
                   }
               end
           else
               name = b[b.size-1]
               target_class = name.at(0).upcase+name.from(1)
           end
           # p "target_class #{target_class}"
           if p == nil
               # targetObj=eval target_class+'.new()'
               klass = target_class.split("::").inject(Object) {|x,y| x.const_get(y) }
               targetObj = klass.new
           else
               # targetObj=eval target_class+".new(\"#{p}\")"
               klass = target_class.split("::").inject(Object) {|x,y| x.const_get(y) }
               targetObj = klass.new(p)
           end
       
       #    targetObj.set(o) if o
           return targetObj
       rescue Exception=>e
           p "load  object '#{path}' failed"
        p "#{e.inspect}\n#{e.backtrace[0..9].join("\n")}"
           # err("#{e.inspect}\n#{e.backtrace[0..9].join("\n")}")
           err e
       end
       
       return nil
       
   end
