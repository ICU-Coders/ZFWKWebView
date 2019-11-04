#
#  Be sure to run `pod spec lint ZFAlertViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |s|
  s.name         = "ZFWKWebView"
  s.version      = "1.1.5"
  s.summary      = "No short description of ZFWKWebView."
  s.homepage     = "https://github.com/FranLucky/ZFWKWebView"
  s.license      = { :type => "MIT", :file => "LICENSE"}
  s.author       = { "Pokeey" => "zhangfan8080@gmail.com" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/FranLucky/ZFWKWebView.git", :tag => "#{s.version}" }
  s.source_files = "ZFWKWebView/*.{h,m,bundle}"
  s.resource     = "ZFWKWebView/ImageResource.bundle"
  s.frameworks   = "Foundation","UIKit"
  s.requires_arc = true
end
