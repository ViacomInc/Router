workspace 'Router'
xcodeproj 'Router'
xcodeproj 'RouterExample'

use_frameworks!

def testing_pods
  pod 'Quick',  '= 0.5.1'
  pod 'Nimble', '= 2.0.0-rc.2'
end

target 'RouterTests' do
  testing_pods
  xcodeproj 'Router'
end

target 'RouterExampleTests' do
  testing_pods
  xcodeproj 'RouterExample'
end
