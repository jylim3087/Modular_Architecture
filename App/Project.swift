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

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
//let project = Project.app(name: "App",
//                          platform: .iOS,
//                          additionalTargets: ["AppKit", "AppUI"])
//

let dependencies: [TargetDependency] =
                                    [
                                        .project(target: "Share", path: "../Share") // Share 프레임워크 추가

                                    ]

let project = Project.generate(dependencies: dependencies)
