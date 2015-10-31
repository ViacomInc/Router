Pod::Spec.new do |s|
  s.name          = "Router"
  s.version       = "0.0.1"
  s.summary       = "A micro routing library written in swift, primarily for deep linking use cases."
  s.homepage      = "https://github.com/ViacomInc/Router"
  s.license       = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author        = "Martino Buffolino"
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/ViacomInc/Router.git", :tag => "swift-2.0" }
  s.source_files  = "Source/*.swift"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc  = true
end
