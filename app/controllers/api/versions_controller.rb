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
       Dir.entries("./public").each do |sub|  
         return sub if sub.include? ".apk"
       end
      return nil   
    end  
     
     
  end
end