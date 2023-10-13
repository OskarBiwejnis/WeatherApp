source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'

target 'WeatherApp' do
  use_frameworks!
  pod 'SnapKit', '~> 5.6.0'
  pod 'SwiftLint'
  pod 'R.swift'
  pod 'RealmSwift', '~>10'
  pod 'CombineCocoa'
  pod 'CombineExt'
  pod 'CombineDataSources', :git => 'https://github.com/Airnauts/CombineDataSources.git', :commit => 'ac74034'
  pod 'Sourcery', '~> 1.6.0'
  pod 'Difference'
  pod 'SwiftyMocky', '~> 4.1.0'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'InjectHotReload'

  target 'WeatherAppTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
	
  end

  target 'WeatherAppUITests' do
    # Pods for testing
  end

end
