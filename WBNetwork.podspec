#
#  Be sure to run `pod spec lint WBNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |s|

  s.name         = "WBNetwork"
  s.version      = "0.1.0"
  s.summary      = "iOS 基于 AFN 封装的链式网络请求框架" 
  s.homepage     = "https://github.com/AllenSWB/WBNetwork"
  s.license      = "MIT"
  s.author       = "AllenSWB"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/AllenSWB/WBNetwork.git", :tag => "#{s.version}" }
  s.frameworks = "Foundation",'UIKit'
  s.source_files  = "WBNetwork", "WBNetwork/WBNetwork/*.{h,m}" 
  s.dependency "AFNetworking", "~> 3.0" 

end
