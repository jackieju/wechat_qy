class SearchController < ApplicationController
    
    def index
        @list = nil
        name = params[:cat]
        word=params[:word]
        cat =  name.at(0).upcase+name.from(1)
        # path = "/#{cat}s?\$filter=contains(CardName,'#{word}') or contains(JournalMemo,'#{word}') or contains(Comments,'#{word}')"
        # path = "/#{cat}s?$filter=contains%28CardName,%27#{word}%27%29%20or%20contains%28JournalMemo,%27#{word}%27%29%20or%20contains%28Comments,%20%27#{word}%27%29"
        args = "$filter=contains(CardName,'#{word}') or contains(JournalMemo,'#{word}') or contains(Comments,'#{word}')"
        path = "/#{cat}s?#{URI.escape(args)}"
        
        resp, full_list = SL.get(path, {"Prefer"=>"odata.maxpagesize=10"})
        if resp == 401
            SL.login
            resp, full_list = SL.get(path, {"Prefer"=>"odata.maxpagesize=10"})
        end
        json = JSON.parse(full_list)
        
        if json
            p "json:#{json.class}"
        
            result_list = []
            json_list  = json["value"]
            p "json_list:#{json_list}"
            if json_list && json_list.size >0
        
                objname = cat
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
                @list = result_list
            end
        end
        render :template=>"#{name}/list.html.erb"
    end
end
