Pod::Spec.new do |s|
  s.name = "William"
  s.version = "1.0.0"
  s.license = "MIT"
  s.summary = "Simple Network Monitor Tool for iOS Application"
  s.author = "Toshinori Watanabe"
  s.homepage = "https://github.com/watanabetoshinori/William"
  s.source = { :git => "git@github.com:watanabetoshinori/William.git", :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/*.{h,swift}'
  s.resources = 'Resources/*.{xib,storyboard}', 'Resources/*.xcassets'

  s.dependency 'Highlightr' 
end
