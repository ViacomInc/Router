workspace 'Router'
xcodeproj 'Router'
xcodeproj 'RouterExample'

use_frameworks!

def testing_pods
    pod 'Quick', '~> 0.3.1'
    pod 'Nimble', '~> 0.4.2'
end

target 'RouterTests' do
  testing_pods
  xcodeproj 'Router'
end

target 'RouterExampleTests' do
  testing_pods
  xcodeproj 'RouterExample'
end
