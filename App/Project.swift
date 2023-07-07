import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains App App target and App unit-test target
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
//let project = Project.app(name: "App",
//                          platform: .iOS,
//                          additionalTargets: ["AppKit", "AppUI"])
//

let dependencies: [TargetDependency] =
                                    [
                                        .project(target: "Share", path: "../Share")
                                    ,   .project(target: "Core", path: "../Core")
                                    ,   .project(target: "EtcModule", path: "../Feature/EtcModule")
                                    ]

let project = Project.generate(dependencies: dependencies)
