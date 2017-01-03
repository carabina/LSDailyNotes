

Pod::Spec.new do |s|

  
  s.name         = "LSDailtNotes"
  s.version      = "1.0.0"
  s.summary      = "A Time CountDown."

  
  s.description  = <<-DESC
  					一个倒计时管理
                   DESC

  s.homepage     = "https://github.com/tianyc1019/LSDailyNotes"
  
  s.license      = "MIT"
 
  s.author             = { "John_LS" => "tianyc1019@icloud.com" }


  # s.platform     = :ios
   s.platform     = :ios, "9.0"

  

  s.source       = { :git => "https://github.com/tianyc1019/LSDailyNotes.git", :tag => "1.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "LSDailyNotes/**/*.{swift}"

  
  



end
