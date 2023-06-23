//
//  CustomSettings.swift
//  ProjectDescriptionHelpers
//
//  Created by 임주영 on 2023/06/23.
//

import ProjectDescription

public struct CustomSettings {
    private let configurations: [AppCustomConfiguration]
    
    public func customConfigurations(for name: String, projectVersion: Version) -> [Configuration] {
        configurations.map { $0.customConfiguration(with: name, projectVersion: projectVersion) }
    }
    
    public func targetCustomConfiguration(for name: String) -> [Configuration] {
        configurations.map { $0.customTargetConfiguration(with: name) }
    }
    
    public init(configurations: [AppCustomConfiguration]) {
        self.configurations = configurations
    }
}
