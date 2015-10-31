Pod::Spec.new do |s|
  s.name          = "Router"
  s.version       = "1.0.0"
  s.summary       = "A micro routing library written in swift, primarily for deep linking use cases."
  s.homepage      = "https://github.com/ViacomInc/Router"
  s.license       = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author        = { 'Martino Buffolino' => 'martino.buffolino@viacom.com' }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/ViacomInc/Router.git", :tag => s.version }
  s.source_files  = "Source/*.swift"
  s.requires_arc  = true

  s.ios.deployment_target = '8.0'

end
