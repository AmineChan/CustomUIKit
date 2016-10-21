Pod::Spec.new do |s|
  s.name         = "CustomUIKit"
  s.version      = "0.0.4"
  s.summary      = "CustomUIKit."
  s.homepage     = "https://github.com/AmineChan"
  s.license      = "MIT"
  s.author       = {"czm" => "328525910@qq.com",}
  s.platform      = :ios, '7.0'

  s.source       = { :git  => "https://github.com/AmineChan/CustomUIKit.git", :tag => s.version }

  s.requires_arc  = true
  s.dependency 'HMSegmentedControl'

  s.source_files  = 'CustomUIKit/*.{h,m}'
  s.resources = 'CustomUIKit/*.{xib,png}'

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
  s.module_name = 'CustomUIKit'
end
