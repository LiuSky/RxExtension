Pod::Spec.new do |s|

  s.name             = "RxExtension"
  s.version          = "0.9.1"
  s.summary          = "Convenience of Rx"

  s.description      = <<-DESC
    This is an Rx extension that provides an easy and straight-forward way
    to use Realm's natively reactive collection type as an Observable
                       DESC

  s.homepage         = "https://github.com/LiuSky/RxExtension"
  s.license          = 'MIT'
  s.author           = { "xiaobin liu" => "327847390@qq.com" }
  s.source           = { :git => "https://github.com/LiuSky/RxExtension.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxExtension/Classes/*.swift'

  s.frameworks = 'Foundation'
  s.frameworks = 'UIKit'
  s.dependency 'RxCocoa', '~> 4.4.0'
  s.dependency 'RxSwift',    '~> 4.4.0'
  s.dependency 'MJRefresh',    '~> 3.1.15.7'
end
