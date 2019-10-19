Pod::Spec.new do |s|
s.name         = "iCimulator"
s.version      = "1.0"
s.summary      = "iCimulator allows us to use camera functions on iOS Simulator."
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = "https://github.com/yuigawada/iCimulator"
s.author       = { "YuigaWada" => "yuigawada@gmail.com" }
s.source       = { :git => "https://github.com/yuigawada/iCimulator.git", :tag => "#{s.version}" }
s.platform     = :ios, "11.0"
s.requires_arc = true
s.source_files = 'iCimulator/**/*.{swift,h}'
s.resources    = 'iCimulator/**/*.{xib,xcassets}'
s.swift_version = "5.0"
end