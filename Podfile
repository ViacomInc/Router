workspace 'Router'
project 'Router'
project 'RouterExample'

use_frameworks!

def testing_pods
  pod 'Quick', '1.2.0'
  pod 'Nimble', '7.0.2'
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
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
