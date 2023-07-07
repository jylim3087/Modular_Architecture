import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains EtcModule App target and EtcModule unit-test target
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

// Creates our project using a helper function defined in ProjectDescriptionHelpers
//let project = Project.app(name: "EtcModule",


let settings: CustomSettings = CustomSettings(configurations: AppCustomConfiguration.allCases)
let name = "EtcModule"
let bundleId = "com.station3.EtcModule"
let projectVersion = Version(0, 1, 0)

let project = Project(
    name: name,
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    settings: .settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
    targets: [
        Target(
            name: "EtcModule",
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
            ],
            resources: [
                "\(name)/**",
            ],
            dependencies: [
                .project(target: "Share", path: "../../Share"), // Share 프레임워크 추가
                .project(target: "Core", path: "../../Core") // Share 프레임워크 추가

            ]
        )
    ]
)
