require 'lib/rubyutility'
require 'fileutils'
def class_exists?(class_name)   
  eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true  
end
def log_msg(m, cat="LOG", stack=0)
    cat = cat.upcase
    trace = ""
    begin
        raise Exception.new
    rescue Exception=>e
        if e.backtrace.size >=2 && stack >= 0
            stack  += 1
            stack = e.backtrace.size-1 if stack >= e.backtrace.size
            trace = e.backtrace[1..stack].join("\n") 
        end
    end
    time = Time.now
    st =  "#{time.strftime("%Y-%m-%d %H:%M:%S")}.#{time.usec.to_s[0,2]}"
    
    if m.is_a?(Exception)
        m = "!!!Exception:#{m.inspect}:\n#{m.backtrace[0..9].join("\n")}"
    end
    msg = "#{st}\##{cat}]\##{m}(#{trace})"


    st2 =  "#{time.strftime("%Y%m%d")}"
    
    froot = g_FILEROOT
    p "===>file root:#{froot}"
    froot = "." if !froot
    dir = "#{froot}/log"
    p "--->dir:#{dir}"
    FileUtils.makedirs(dir)   
    fname = "#{dir}/#{cat}_#{st2}.sg"
     p "==>log msg #{fname}: #{msg}"
    append_file(fname, msg)    
end
def pe(e, deep =9)
    "!!!Exception:#{e.inspect}:\n#{e.backtrace[0..deep].join("\n")}"
end
def p_f(m)
    # p "|==>perf(#{$uid}):(#{Time.now.to_f}) #{m}" if $uid==1909
   # p "|==>perf(#{$uid}):(#{Time.now.to_f}) #{m}" if $uid==25579#  玩玩走走
end

#### log on rails #####
def p(m, stack=0)
    if stack >0
         begin
            raise Exception.new
        rescue Exception=>e
            if e.backtrace.size >=2 
                stack  += 1
                stack = e.backtrace.size-1 if stack >= e.backtrace.size
                trace = e.backtrace[1..stack].join("\n") 
                m = "#{m}\n#{trace}"
            end
        end
    end
    # puts m
    # if class_exists?("Rails.logger")
        Rails.logger.debug(m) 
    # else
        print "#{m}\n"
    # end
end
def warn(m)
    # Rails.logger.warn(m)
end
def err(m)
    if m.is_a?(Exception)
        m = "!!!Exception:#{m.inspect}:\n#{m.backtrace[0..9].join("\n")}"
    end
    if class_exists?("Rails.logger")
        Rails.logger.error(m) 
    else
        print "#{m}\n"
    end
end

class SlowLog
    @@th = 1 #threshhold
    
    # stack level is where the log caller located
    def _in(stack = 2)
        trc = ""
        begin
            raise Exception.new
        rescue Exception=>e
            trc = e.backtrace[stack]
        end
        
        @t = Time.now.to_f
       
        @buf = <<__END1__
        \n========= slow log ========
        pid: #{$$}
        file: #{trc}
        time: #{@t}
__END1__
        
        @log_num = 0
    end
    def self.in(stack = 2)
        h = SlowLog.new
        
        h._in(stack)
        # h.log
        
        return h
    end
    def _out
        t2 = Time.now.to_f
        # if true
        span = t2 - @t
        if span > @@th 
            # p @buf
            # p @buf = "========= END slow log ========\n"
            @buf += "Span #{span}\n"
            @buf += "========= END slow log ========\n"
            log_msg(@buf, "SLOWLOG")
        end
    end
    def self.out(h)
        h._out
    end
    def self.out1(h)
        h._out
    end
    def log(m="", stack=2)
        trc = ""
        begin
            raise Exception.new
        rescue Exception=>e
            trc = e.backtrace[stack]
        end
        @buf += "[#{$$}\##{@log_num}@#{Time.now.to_f}] #{m} (#{trc})\n"
        @log_num += 1
    end
    
    
end



# def test_slowlog
#     _hh = SlowLog.in
#     _hh.log("sff")
#     sleep(2)
#     _hh.log
#     _hh.log
#     SlowLog.out(_hh)
# end


# test_slowlog