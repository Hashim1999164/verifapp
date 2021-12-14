Pod::Spec.new do |s|
  s.name             = 'verifapp'
  s.version          = '1.0.1'
  s.summary          = 'SDK to Verify Your Phone Numbers'
  s.description      = 'Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing Currently Testing'
  s.homepage         = 'https://github.com/Hashim1999164/verifapp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { 'Hashim Khan' => 'sardarhashim30@gmail.com' }
  s.source           = { :git => 'https://github.com/Hashim1999164/verifapp.git', :tag => 'v1.0.1' }
  s.ios.deployment_target = '12.0'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'Alamofire', '~> 5.4.4'
  s.dependency 'SwiftyJSON', '~> 5.0.1'
  s.dependency 'PhoneNumberKit', '~> 3.3.3'
  s.dependency 'SwiftKeychainWrapper', '~> 4.0.1'
  s.exclude_files = "Classes/Exclude"
  s.swift_versions = '5.0'
end
