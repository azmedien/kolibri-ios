#
# Be sure to run `pod lib lint Kolibri.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Kolibri'
  s.version          = '0.1.2'
  s.summary          = 'This is Kolibri Library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/azmedien/kolibri-ios.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'slav.sarafski' => 'slav@spiritinvoker.com' }
  s.source           = { :git => 'https://github.com/azmedien/kolibri-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Kolibri/Classes/**/*'

  # s.resource_bundles = {
  #   'Kolibri' => ['Kolibri/Assets/*.png']
  # }

  
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'SideMenu', '~> 2.3.3.0'
  s.dependency 'SDWebImage', '~>3.8'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'SwiftGifOrigin', '~> 1.6.1'
  s.dependency 'Localize-Swift', '~> 1.7'
end
