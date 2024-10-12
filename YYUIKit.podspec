
Pod::Spec.new do |s|
  s.name             = 'YYUIKit'
  s.version          = '0.5.8'
  s.summary          = 'YYUIKit 是我在开发中总结的一套 UI 类库'

  s.description      = <<-DESC
    YYUIKit 是一组在开发工作中逐渐总结的常用工具库。
    旨在总结和记录减少重复的造轮子，提升效率，节省时间，同时让开发工作更专注
                       DESC

  s.homepage         = 'https://github.com/xiaoyouPrince/XYUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiaoyouPrince' => 'xiaoyouPrince@163.com' }
  s.source           = { :git => 'https://github.com/xiaoyouPrince/XYUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  # s.source_files = 'XYUIKit/Classes/**/*'
  # s.resources      = "XYUIKit/Localize/*.lproj"
  
  s.subspec 'Foundation' do |sub|
    sub.source_files   = "XYUIKit/Classes/Foundation/**/*"
  end
    
  s.subspec 'UIKit' do |sub|
    sub.source_files   = 'XYUIKit/Classes/UIKit/**/*'
    sub.resource_bundles = {
      'XYUIKit' => ['XYUIKit/Assets/**/*']
    }
    
    sub.dependency 'YYUIKit/Foundation'
    sub.dependency 'SnapKit'
  end
  
  s.subspec 'Auth' do |sub|
    sub.source_files   = 'XYUIKit/Classes/Authority/**/*'
    
    sub.dependency 'YYUIKit/UIKit'
  end
  
end
