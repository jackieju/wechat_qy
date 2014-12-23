def preload_models_in_rails()  
    # t = Time.now.to_f
    count = 0
    # p "#{File.dirname(__FILE__)}/lib/**/*.rb"
    # path = "#{File.dirname(__FILE__)}/../../lib/**/*.rb" # in application_controller
    path = "#{File.dirname(__FILE__)}/**/*.rb"   # run in utility.rb
   path = "#{RAILS_ROOT}/lib/**/*.rb"   # run in anywhere
    
    Dir[path].each { |f|
        p "loading #{f}"
        load(f)
         count +=1
     }
     # p "preload_models costs #{Time.now.to_f- t}"
     p "preload #{count} files"
end