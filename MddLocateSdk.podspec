Pod::Spec.new do |s|
    s.name         = "MddLocateSdk"
    s.version      = "0.0.11"
    s.summary      = "Pod version of the ios sdk for mdd locate."
    #s.description  = <<-DESC
    #An extended description of MyFramework project.
    #DESC
    s.homepage     = "https://github.com/Mobile-Dealer/mdd-locate-swift"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2018
                   Permission is granted to...
                  LICENSE
                }
    s.author             = "Mobile Dealer Data" 
    s.source       = { :git => "/Users/marcchapman/dev/mdd/mdd-locate-swift", :branch => "podspec", :tag => "#{s.version}" }    
    s.source_files = "LocateSDK.xcframework/Headers/**/*.h"
    #s.public_header_files = "LocateSDK.xcframework/Headers/*.h"
    s.vendored_frameworks = "LocateSDK.xcframework"
    s.platform = :ios
    s.swift_version = "4.2"
    s.ios.deployment_target  = '12.0'
end
