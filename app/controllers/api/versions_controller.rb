module Api
  class VersionsController < Api::BaseController
    
    def last_version
      @apk_name = apk_name()
      @version = @apk_name[@apk_name.index("_")+1...@apk_name.index(".apk")] if @apk_name
    end
    
    def apk
      apk_name = apk_name()
      redirect_to "/#{apk_name}"
    end
    
    def apk_name() 
      if Socket.gethostname == "AY131203213614306c1aZ"
        public_dir = "/home/jinwanlin/test3/public"
      else
        public_dir = "/Users/jinwanlin/workspace/test3/public"
      end
     
      Dir.entries(public_dir).each do |sub|  
        return sub if sub.include? ".apk"
      end
      
      return nil   
    end  
     
     
  end
end