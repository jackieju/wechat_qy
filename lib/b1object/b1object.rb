require "sl.rb"
class B1object
    
    def initialize(p=nil)
        @data = p
    end
    def data
        @data
    end
    
    def [](n)
        @data = {} if @data == nil
        d = @data[n.to_sym]
        return d if d
        return @data[n.to_s]
    end
    
    def []=(n, v)
        @data = {} if @data == nil
        @data[n.to_sym] = v
    end
    
    # path=>"/Invoices", name=>"invoice"
    def name
        "dummy"
    end
    
    def objectname
        name.at(0).upcase+name.from(1)
    end
    
    def listname
        cname = objectname+"s"
    end
    
    def list_column
        []
    end
 
    def self.get(name, id, usecache=true)
        objname =  name.at(0).upcase+name.from(1)
        if usecache
            item = $memcached.get("#{name}\##{id}")
            return item if item
            p "not in cache, #{name} #{id}"
        else
            p "no use cache, #{name} #{id}"
        end
       
        resp, full_list = SL.get("/#{objname}s?\$filter=DocEntry%20eq%20#{id}", {"Prefer"=>"odata.maxpagesize=10","Cookie"=>$slcookie})
        json = JSON.parse(full_list)
        p "json:#{json.class}"
        result_list = []
        json_list  = json["value"]
        p "json_list:#{json_list}"
        return nil if json_list.size == 0
        
        d =json_list[0]
        obj = loadObject(objname)
        obj[:DocEntry] = d["DocEntry"]
        obj.list_column.each{|f|
            obj[f.to_sym] = d[f]
        }
        p "obj=>#{obj.inspect}"
        $memcached.set("#{name}\##{d["DocEntry"]}", loadObject(objname, d))
        result_list.push(obj)
        p "add object"
        
        
        return result_list
    end
    def self.list(name, usecache=true)
        objname =  name.at(0).upcase+name.from(1)
        if usecache
            list = $memcached.get("#{objname}s")
            return list if list
            p "not in cache, #{name} list"
        else
            p "no use cache, #{name} list"
        end
       
        # resp, full_list = SL.get("/#{objname}s", {"Prefer"=>"odata.maxpagesize=10","Cookie"=>$slcookie})
        resp, full_list = SL.get("/#{objname}s", {"Prefer"=>"odata.maxpagesize=10"})
        
        save_to_file(full_list, "invoices.data")
        json = JSON.parse(full_list)
        p "json:#{json.class}"
        result_list = []
        json_list  = json["value"]
        p "json_list:#{json_list}"
        
        json_list.each{|d|
            obj = loadObject(objname)
            obj[:DocEntry] = d["DocEntry"]
            obj.list_column.each{|f|
                obj[f.to_sym] = d[f]
            }
            p "obj=>#{obj.inspect}"
            
            dd = loadObject(objname)
            d.each{|k,v|
                dd[k]=v
            }
            $memcached.set("#{name}\##{d["DocEntry"]}", dd)
            result_list.push(obj)
            p "add object"
        }
        $memcached.set("#{objname}s", result_list)
        
        return result_list
    end

end
