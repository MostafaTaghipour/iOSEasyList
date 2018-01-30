#
# Be sure to run `pod lib lint iOSEasyList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'iOSEasyList'
s.version          = '1.0.1'
s.summary          = 'A data-driven UICollectionView and UITableView framework for building fast and flexible lists'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Framework to simplify the setup and configuration of UITableView and UICollectionView data sources and cells. It allows a type-safe setup of (UITableView,UICollectionView) DataSource and Delegate. DataSource also provides out-of-the-box diffing and animated deletions, inserts, moves and changes.
DESC

s.homepage         = 'https://github.com/MostafaTaghipour/iOSEasyList'
# s.screenshots     = 'https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/animation-ios.gif', 'https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/expandable_ios.gif','https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/filtering-ios.gif','https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/layout-ios.gif','https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/message-ios.gif','https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/pagination-ios.gif','https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/sectioned-ios.gif'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Mostafa Taghipour' => 'mostafa.taghipour@ymail.com' }
s.source           = { :git => 'https://github.com/MostafaTaghipour/iOSEasyList.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'

s.source_files = 'iOSEasyList/Classes/**/*'

# s.resource_bundles = {
#   'iOSEasyList' => ['iOSEasyList/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
