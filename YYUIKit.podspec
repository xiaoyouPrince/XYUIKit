#
# Be sure to run `pod lib lint XYNav.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YYUIKit'
  s.version          = '0.0.4'
  s.summary          = 'YYUIKit 是我在开发中总结的一套 UI 类库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    YYUIKit 是一组在开发工作中逐渐总结的常用工具库。
    旨在总结和记录减少重复的造轮子，提升效率，节省时间，同时让开发工作更专注
                       DESC

  s.homepage         = 'https://github.com/xiaoyouPrince/XYUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiaoyouPrince' => 'xiaoyouPrince@163.com' }
  s.source           = { :git => 'https://github.com/xiaoyouPrince/XYUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.swift_version = '5.0'

  s.source_files = 'XYUIKit/XYUIKit/XYUIKit/Classes/**/*'
  s.dependency 'SnapKit'
  
  # s.resource_bundles = {
  #   'XYNav' => ['XYNav/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
