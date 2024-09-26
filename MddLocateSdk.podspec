Pod::Spec.new do |s|
    s.name         = "MddLocateSdk"
    s.version      = "0.0.10"
    s.summary      = "ios sdk for mdd locate."
    s.homepage     = "https://github.com/Mobile-Dealer/mdd-locate-swift"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   See Mobile Dealer Data for license information
                  LICENSE
                }
    s.author             = "Mobile Dealer Data" 
    s.source       = { :git => "https://github.com/Mobile-Dealer/mdd-locate-swift.git", :tag => "#{s.version}" }    
    s.vendored_frameworks = "LocateSDK.xcframework"
    s.platform = :ios
    s.swift_version = "4.2"
    s.ios.deployment_target  = '12.0'
end
