workspace 'Router'
xcodeproj 'Router'
xcodeproj 'RouterExample'

use_frameworks!

def testing_pods
  pod 'Quick', '~> 0.8.0'
  pod 'Nimble', '3.0.0'
end

target 'RouterTests' do
  testing_pods
  xcodeproj 'Router'
end

target 'RouterExampleTests' do
  testing_pods
  xcodeproj 'RouterExample'
end
