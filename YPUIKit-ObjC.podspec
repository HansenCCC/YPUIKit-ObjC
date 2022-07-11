#
# Be sure to run `pod lib lint YPUIKit-ObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YPUIKit-ObjC'
  s.version          = '1.0.0'
  s.summary          = 'YPUIKit-ObjC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Some UI components
                       DESC

  s.homepage         = 'https://github.com/HansenCCC/YPUIKit-ObjC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenghengsheng' => 'chenghs@shinemo.com' }
  s.source           = { :git => 'https://github.com/chenghengsheng/YPUIKit-ObjC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'YPUIKit-ObjC/Classes/**/*'
  
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'MJRefresh', '~> 3.7.5'
  
  # s.resource_bundles = {
  #   'YPUIKit-ObjC' => ['YPUIKit-ObjC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
