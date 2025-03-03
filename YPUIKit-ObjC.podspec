#
# Be sure to run `pod lib lint YPUIKit-ObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YPUIKit-ObjC'
  s.version          = '1.3.0'
  s.summary          = 'YPUIKit-ObjC.'
  s.description      = <<-DESC
  YPUIKit-ObjC 设计目的是为了快速搭建一个 iOS 项目，提高项目 UI 开发效率。
                       DESC
  s.homepage         = 'https://github.com/HansenCCC/YPUIKit-ObjC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenghengsheng' => '2534550460@qq.com' }
  s.source           = { :git => 'https://github.com/HansenCCC/YPUIKit-ObjC', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'YPUIKit-ObjC/Classes/**/*'
  
  s.module_name = 'YPUIKit'
  
end
