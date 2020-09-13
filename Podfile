# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/xhamr/fave-button'
use_frameworks!


target 'Insapp' do

  # Pods for Insapp
  pod 'Alamofire', '~> 4.0'
  pod 'FaveButton'
  pod 'Google/Analytics'
  pod 'Fabric'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Bagel', '~>  1.3.2'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end

end
