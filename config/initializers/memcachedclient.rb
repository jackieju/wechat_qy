require 'memcache.rb'
require 'settings.rb'
require 'railsutility.rb'

mcd_default_options = {
        :namespace => 'b1s:sl',
        :memcache_server => "localhost:#{g_memcached_b1objcache_port}"
}

if (!$memcached)  
    $memcached= MemCache.new(mcd_default_options[:memcache_server], mcd_default_options)
end

# rcd_default_options = {
#         :namespace => 'game:room',
#         :memcache_server => "localhost:#{g_memcached_roomcache_port}"
# }
# 
# if (!$roomcached)  
#     $roomcached= MemCache.new(rcd_default_options[:memcache_server], rcd_default_options)
# end

p "==>memcached(#{$memcached.class}) all method:"+MemCache.instance_methods.inspect
# file,line = MemCache.source
# p "#{file}"
p "=====>preload ruby files"
preload_models_in_rails
