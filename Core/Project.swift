import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains Core App target and Core unit-test target
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

let settings: CustomSettings = CustomSettings(configurations: AppCustomConfiguration.allCases)
let name = "Core"
let bundleId = "com.station3.Core"
let projectVersion = Version(0, 1, 0)

let project = Project(
    name: name,
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    settings: .settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
    targets: [
        Target(
            name: "Core",
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
                .project(target: "Share", path: "../Share")
            ]
        )
    ]
)
