Pod::Spec.new do |s|
  s.name             = 'JJSLib'
  s.version          = '1.0.0'
  s.summary          = 'JJSLib JJSLib.'
  s.homepage         = 'https://gitee.com/devjackcat/JJSLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'devjackcat' => 'devjackcat@163.com' }
  
  s.source           = { :git => 'https://gitee.com/devjackcat/JJSLib.git', :branch => 'master' }
  s.requires_arc = true;
  
  s.source_files  = ['JJSLib/Source/**/*.{h,m,c,swift}']
  s.public_header_files = ['JJSLib/Source/**/*.{h}']
  
  s.platform     = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target  = '10.15'
  s.requires_arc = true
  
    s.dependency 'SnapKit'
    s.dependency 'RxSwift'
    s.dependency 'Closures'
    s.dependency 'RxCocoa'
#    s.dependency 'UIColor_Hex_Swift'
    s.dependency 'Kingfisher'
#    s.dependency 'GumboHTMLTransform'
    s.dependency 'YYText'
    s.dependency 'CryptoSwift'
    s.dependency 'SwiftyRSA'
    s.dependency 'Alamofire'
    s.dependency 'MJRefresh'
    s.dependency 'SDWebImage'
    s.dependency 'KeychainAccess'
    
end
