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

let settings: CustomSettings = CustomSettings(configurations: AppCustomConfiguration.allCases)
let name = "Share"
let bundleId = "com.station3.Share"
let projectVersion = Version(0, 1, 0)

let project = Project(
    name: name,
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: Dependency.packages,
    settings: .settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
    targets: [
        Target(
            name: "Share",
            platform: .iOS,
            product: .framework,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: [
                "\(name)/**",
                "DesignSystem/**",
            ],
            resources: [
                "\(name)/**",
                "DesignSystem/Colors/*.xcassets",
                "DesignSystem/ImageAssets/*.xcassets",
            ],
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
