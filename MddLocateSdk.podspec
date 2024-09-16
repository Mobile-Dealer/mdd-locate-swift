Pod::Spec.new do |s|
    s.name         = "MddLocateSdk"
    s.version      = "0.0.17"
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
    s.source       = { :git => "https://github.com/Mobile-Dealer/mdd-locate-swift.git", :branch => "podspec", :tag => "#{s.version}" }    
    s.vendored_frameworks = "LocateSDK.xcframework"
    s.platform = :ios
    s.swift_version = "4.2"
    s.ios.deployment_target  = '12.0'
end
