#
# Be sure to run `pod lib lint LeakChecker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LeakChecker'
  s.version          = '1.0.0'
  s.summary          = 'Simple memory leak checker'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Memory leak checker based on weak reference examination.
  DESC

  s.homepage         = 'https://github.com/maxol85/LeakChecker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Sol' => 'mswork85@gmail.com' }
  s.source           = { :git => 'https://github.com/maxol85/LeakChecker.git', :tag => s.version.to_s }

  # s.source_files = 'LeakChecker/Classes/**/*'
  
  s.resource_bundles = {
    'LeakChecker' => ['LeakChecker/Assets/**/*']
  }

  s.swift_version = '5.0'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.default_subspec = "UI"

  s.subspec 'Core' do |subspec|
    subspec.ios.deployment_target = '10.0'
    subspec.osx.deployment_target = '10.13'
    subspec.tvos.deployment_target = '10.0'
    subspec.watchos.deployment_target = '3.0'

    subspec.source_files = 'LeakChecker/Classes/Core/**/*'
  end

  s.subspec 'Utils' do |subspec|
    subspec.ios.deployment_target = '10.0'
    subspec.tvos.deployment_target = '10.0'

    subspec.source_files = 'LeakChecker/Classes/Utils/**/*'
  end

  s.subspec 'UI' do |subspec|
    subspec.ios.deployment_target = '10.0'
    subspec.tvos.deployment_target = '10.0'

    subspec.source_files = 'LeakChecker/Classes/UI/**/*'
    subspec.dependency "LeakChecker/Core"
    subspec.dependency "LeakChecker/Utils"
  end
end
