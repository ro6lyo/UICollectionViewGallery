#
# Be sure to run `pod lib lint UICollectionViewGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICollectionViewGallery'
  s.version          = '0.1.4'
  s.summary          = 'highly customizable uicollectionview gallery'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'longed description will be added later this is testing pod'

  s.homepage         = 'https://github.com/ro6lyo/UICollectionViewGallery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ro6lyo' => 'roshlyo@icloud.com' }
  s.source           = { :git => 'https://github.com/ro6lyo/UICollectionViewGallery.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'UICollectionViewGallery/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UICollectionViewGallery' => ['UICollectionViewGallery/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
