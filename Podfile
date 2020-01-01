workspace 'Router'
project 'Router'
project 'RouterExample'

platform :ios, '8.3'
use_frameworks!

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

target 'RouterTests' do
  testing_pods
  project 'Router'
end

target 'RouterExampleTests' do
  testing_pods
  project 'RouterExample'
end
