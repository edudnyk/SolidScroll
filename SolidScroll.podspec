Pod::Spec.new do |s|
  s.name = 'SolidScroll'
  s.version = '0.0.1'
  s.license = 'MIT License'
  s.summary = 'A liberated _ScrollView and _PagingView of SwiftUI.'
  s.description = 'Get near-UIScrollView control over the status of scrolling in real time, content insets, animate content offset, and much more.'
  s.homepage = 'https://github.com/edudnyk/SolidScroll'
  s.authors = { 'Eugene Dudnyk' => 'edudnyk@gmail.com' }
  s.source = { :git => 'https://github.com/edudnyk/SolidScroll.git', :tag => s.version }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/SolidScroll/**/*.{h,swift}'
  s.preserve_paths = 'Sources/SolidScroll/SolidScroll.docc'
  s.swift_version = '5.5'
end
