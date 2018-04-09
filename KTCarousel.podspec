#
# Be sure to run `pod lib lint KTCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTCarousel'
  s.version          = '2.1'
  s.summary          = 'A side scrolling, zoomable carousel.'

  s.description      = <<-DESC
This is a framework for displaying UIImages in a side scrolling collection view with a custom UIViewController transition between zoomed-in and zoomed-out view controllers.
                       DESC

  s.homepage         = 'https://github.com/kvtaniguchi/KTCarousel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Taniguchi' => 'kvtaniguchi@gmail.com' }
  s.source           = { :git => 'https://github.com/kvtaniguchi/KTCarousel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'KTCarousel/Classes/**/*'

end
