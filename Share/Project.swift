import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains Share App target and Share unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
//let project = Project.app(name: "Share",
//                          platform: .iOS,
//                          additionalTargets: ["ShareKit", "ShareUI"])

private var packages: [Package] {
    return [
        .package(url: "https://github.com/danielgindi/Charts.git",              .exact("4.1.0")),
        .package(url: "https://github.com/evgenyneu/Cosmos.git",                .exact("23.0.0")),
        .package(url: "https://github.com/zhangao0086/DKImagePickerController.git",  .branch("master")),
        .package(url: "https://github.com/layoutBox/FlexLayout.git",            .exact("1.3.21")),
        .package(url: "https://github.com/ryuickhwna/FlexiblePageControl.git",  .branch("master")),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git",  .exact("6.5.6")),
        .package(url: "https://github.com/onevcat/Kingfisher.git",              .branch("version6-xcode13")),
        .package(url: "https://github.com/hyperoslo/Lightbox.git",              .branch("master")),
        .package(url: "https://github.com/Moya/Moya.git",                       .exact("15.0.0")),
        .package(url: "https://github.com/layoutBox/PinLayout.git",             .exact("1.9.3")),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git",           .exact("3.1.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git",         .exact("2.12.4")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git",  .exact("5.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git",                 .exact("5.0.1")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git",             .exact("1.13.0")),
        .package(url: "https://github.com/fbdlrghks123/Toaster.git",            .branch("xcode12")),
        .package(url: "https://github.com/devxoul/Then.git",                    .exact("3.0.0")),
        .package(url: "https://github.com/airbnb/lottie-ios.git",                    .exact("3.2.3"))
    ]
}

//let firebaseDependencies: [TargetDependency] = [
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseABTesting.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseAnalytics.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseCore.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseCoreDiagnostics.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseCrashlytics.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseDynamicLinks.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseInstallations.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseMessaging.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/FirebaseRemoteConfig.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/GoogleAppMeasurement.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/GoogleDataTransport.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/GoogleUtilities.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/nanopb.xcframework"),
//    .xcframework(path: "Tuist/Dependencies/Carthage/Build/PromisesObjC.xcframework")
//]

//let menualDependencies: [TargetDependency] = [
//    .xcframework(path: Path("Tuist/Dependencies/Frameworks/NMapsMap.xcframework")),
//    .xcframework(path: Path("Tuist/Dependencies/Carthage/Build/UITextView_Placeholder.xcframework")),
//    .xcframework(path: Path("Tuist/Dependencies/Carthage/Build/WKWebViewJavascriptBridge.xcframework"))
//]

let settings: CustomSettings = CustomSettings(configurations: AppCustomConfiguration.allCases)
let name = "Share"
let projectVersion = Version(0, 1, 0)

let project = Project(
    name: name,
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: packages,
    settings: .settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
    targets: [
        Target(
            name: "Share",
            platform: .iOS,
            product: .framework, // <-
            bundleId: "com.station3.Share",
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Sources/**"], // Sources/**누락 시 .swift 파일 수동으로 add files해야 추가됨
            resources: ["Resources/**"], // Sources/**누락 시 LaunchScreen.storyboard 파일 수동으로 add files해야 추가됨
            dependencies: [
                .package(product: "Charts"),
                .package(product: "Cosmos"),
                .package(product: "Differentiator"),
                .package(product: "DKImagePickerController"),
                .package(product: "FlexiblePageControl"),
                .package(product: "IQKeyboardManagerSwift"),
                .package(product: "Kingfisher"),
                .package(product: "Lightbox"),
                .package(product: "ReactorKit"),
                .package(product: "RxDataSources"),
                .package(product: "RxFlow"),
                .package(product: "RxMoya"),
                .package(product: "SkeletonView"),
                .package(product: "SnapKit"),
                .package(product: "Then"),
                .package(product: "Toaster"),
                .package(product: "FlexLayout"),
                .package(product: "PinLayout"),
                .package(product: "Lottie")
            ]
        )
    ]
)
