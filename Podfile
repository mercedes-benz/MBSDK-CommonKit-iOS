source 'https://github.com/CocoaPods/Specs.git'

platform :ios,'12.0'
use_frameworks!
inhibit_all_warnings!
workspace 'MBCommonKit'


def pods
  # code analyser
  pod 'SwiftLint', '~> 0.30'
end


target 'Example' do
	project 'Example/Example'
	
	pods
end

target 'MBCommonKit' do
	project 'MBCommonKit/MBCommonKit'
	
	pods

	target 'MBCommonKitTests' do
	end
end
