workspace 'Router'
project 'Router'
project 'RouterExample'

use_frameworks!

def testing_pods
  pod 'Quick', '0.10.0'
  pod 'Nimble', '5.0.0'
end

target 'RouterTests' do
  testing_pods
  project 'Router'
end

target 'RouterExampleTests' do
  testing_pods
  project 'RouterExample'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
