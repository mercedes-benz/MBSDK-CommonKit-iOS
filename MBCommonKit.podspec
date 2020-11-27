Pod::Spec.new do |s|
  s.name          = "MBCommonKit"
  s.version       = "3.0.0"
  s.summary       = "MBCommonKit" 
  s.description   = "MBCommonKit is a public Pod of MBition GmbH"
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-CommonKit-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '12.0'
  s.swift_version = ['5.0', '5.1', '5.2', '5.3']

  s.default_subspec = 'All'

  s.subspec "All" do |sp|
    sp.dependency 'MBCommonKit/Logger'
    sp.dependency 'MBCommonKit/Protocols'
    sp.dependency 'MBCommonKit/Tracking'
  end

  s.subspec "Logger" do |sp|
    sp.source_files = 'MBCommonKit/MBCommonKitLogger/**/*.{swift}'
  end

  s.subspec "Protocols" do |sp|
    sp.source_files = 'MBCommonKit/MBCommonKit/**/*.{swift}'
  end

  s.subspec "Tracking" do |sp|
    sp.source_files = 'MBCommonKit/MBCommonKitTracking/**/*.{swift}'
  end
end
