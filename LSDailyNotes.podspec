

Pod::Spec.new do |s|

  
  s.name         = "LSDailyNotes"
  s.version      = "1.0.1"
  s.summary      = "A Time CountDown."

  
  s.description  = <<-DESC
            一个倒计时管理
                   DESC

  s.homepage     = "https://github.com/tianyc1019/LSDailyNotes"
  
  s.license      = "MIT"
 
  s.author             = { "John_LS" => "tianyc1019@icloud.com" }


  # s.platform     = :ios
   s.platform     = :ios, "9.0"

  

  s.source       = { :git => "https://github.com/tianyc1019/LSDailyNotes.git", :tag => "1.0.1" }


  

  s.source_files  = "LSDailyNotes/**/*.{swift}"

  
  



end
