Pod::Spec.new do |s|
  s.name             = 'LeakChecker'
  s.version          = '1.0.0'
  s.summary          = 'Simple memory leak checker'

  s.description      = <<-DESC
  Memory leak checker based on weak reference examination.
  DESC

  s.homepage         = 'https://github.com/maxol85/LeakChecker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Sol' => 'maxoldev@gmail.com' }
  s.source           = { :git => 'https://github.com/maxoldev/LeakChecker.git', :tag => s.version.to_s }

  s.resource_bundles = {
    'LeakChecker' => ['LeakChecker/Assets/**/*']
  }

  s.swift_versions = ['5']

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '3.0'

  s.ios.source_files = 'LeakChecker/Classes/Core/**/*', 'LeakChecker/Classes/Utils/**/*', 'LeakChecker/Classes/UIKit-Utils/**/*', 'LeakChecker/Classes/UIKit-UI/**/*'
  s.tvos.source_files = 'LeakChecker/Classes/Core/**/*', 'LeakChecker/Classes/Utils/**/*', 'LeakChecker/Classes/UIKit-Utils/**/*', 'LeakChecker/Classes/UIKit-UI/**/*'
  s.osx.source_files = 'LeakChecker/Classes/Core/**/*'
  s.watchos.source_files = 'LeakChecker/Classes/Core/**/*'
end
