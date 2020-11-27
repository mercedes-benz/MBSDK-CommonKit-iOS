// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "MBCommonKit",
	platforms: [
		.iOS(.v12),
	],
	products: [
		.library(name: "MBCommonKit",
				 targets: [
					"MBCommonKit",
					"MBCommonKitLogger",
					"MBCommonKitTracking"
				 ])
	],
	dependencies: [
		.package(url: "https://github.com/Quick/Nimble.git",
				 .upToNextMajor(from: "8.0.0")),
		.package(url: "https://github.com/Quick/Quick.git",
				 .upToNextMajor(from: "2.0.0"))
	],
	targets: [
		.target(name: "MBCommonKit",
				path: "MBCommonKit/MBCommonKit",
				exclude: ["Info.plist"]),
		.target(name: "MBCommonKitLogger",
				path: "MBCommonKit/MBCommonKitLogger",
				exclude: ["Info.plist"]),
		.target(name: "MBCommonKitTracking",
				path: "MBCommonKit/MBCommonKitTracking",
				exclude: ["Info.plist"]),
		.testTarget(name: "MBCommonKitTests",
					dependencies: [
						.byName(name: "MBCommonKit"),
						.byName(name: "Nimble"),
						.byName(name: "Quick")
					],
					path: "MBCommonKit/MBCommonKitTests",
					exclude: ["Info.plist"]),
		.testTarget(name: "MBCommonKitLoggerTests",
					dependencies: [
						.byName(name: "MBCommonKitLogger"),
						.byName(name: "Nimble"),
						.byName(name: "Quick"),
					],
					path: "MBCommonKit/MBCommonKitLoggerTests",
					exclude: ["Info.plist"]),
		.testTarget(name: "MBCommonKitTrackingTests",
					dependencies: [
						.byName(name: "MBCommonKitTracking"),
						.byName(name: "Nimble"),
						.byName(name: "Quick"),
					],
					path: "MBCommonKit/MBCommonKitTrackingTests",
					exclude: ["Info.plist"])
	],
	swiftLanguageVersions: [.v5]
)
