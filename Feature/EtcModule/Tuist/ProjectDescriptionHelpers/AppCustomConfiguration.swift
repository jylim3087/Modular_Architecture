import ProjectDescription

public enum AppCustomConfiguration: CaseIterable {
    case debug
    case release
    case release_enableServerChange
    
    public func customConfiguration(with name: String, projectVersion: Version) -> Configuration {
        switch self {
        case .debug:
            return Configuration.debug(name: ConfigurationName(stringLiteral: configurationName), settings: settings(with: name, projectVersion: projectVersion))
        case .release, .release_enableServerChange:
            return Configuration.release(name: ConfigurationName(stringLiteral: configurationName), settings: settings(with: name, projectVersion: projectVersion))
        }
    }
    
    public func customTargetConfiguration(with name: String) -> Configuration {
        switch self {
        case .debug:
            return Configuration.debug(name: ConfigurationName(stringLiteral: configurationName), settings: targetSettings(with: name))
        case .release, .release_enableServerChange:
            return Configuration.release(name: ConfigurationName(stringLiteral: configurationName), settings: targetSettings(with: name))
        }
    }
    
    private var configurationName: String {
        switch self {
        case .debug:
            return "Debug"
        case .release:
            return "Release"
        case .release_enableServerChange:
            return "Release_ServerChange"
        }
    }
    
    private func settings(with name: String, projectVersion: Version) -> [String: SettingValue] {
        let base: [String: SettingValue] = [
            "MARKETING_VERSION": SettingValue(stringLiteral: projectVersion.description),
            "GCC_PREPROCESSOR_DEFINITIONS": .array(["$(inherited)", "FLEXLAYOUT_SWIFT_PACKAGE=1"])
        ]
//            "ACK_ENVIRONMENT_DIR": "$(PROJECT_DIR)/$(TARGET_NAME)/Environment",
//            "ACK_PROJECT_VERSION": SettingValue(stringLiteral: projectVersion.description),
//            "DEVELOPMENT_TEAM": "PXDF48X6VX",
//            "OTHER_LDFLAGS": "-ObjC",
//            "ENABLE_BITCODE": "NO",
//            "INFOPLIST_PREPROCESS": "YES",
//            "INFOPLIST_PREFIX_HEADER": "$(ACK_ENVIRONMENT_DIR)/.environment_preprocess.h",
//            "CODE_SIGN_STYLE": "Manual",
//        ]
        
        switch self {
        case .debug:
            let debugSettings: [String: SettingValue] = [
                "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": "YES",
                "CODE_SIGN_IDENTITY": "iPhone Developer",
                "IPHONEOS_DEPLOYMENT_TARGET": "13.0",
                "SDKROOT": "iphoneos",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                "SWIFT_OPTIMIZATION_LEVEL": "-O",
                "SWIFT_SWIFT3_OBJC_INFERENCE": "Default",
                "SWIFT_VERSION": "",
                "TARGETED_DEVICE_FAMILY": "1",
                "DEBUG_INFORMATION_FORMAT": "dwarf",
                "CLANG_CXX_LANGUAGE_STANDARD": "gnu++0x",
                "GCC_C_LANGUAGE_STANDARD": "gnu99",
                
                "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION": "YES"
            ]
            return base.merging(debugSettings, uniquingKeysWith: { _, debug in debug })
        case .release:
            let releaseSettings: [String: SettingValue] = [
                "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": "YES",
                "CODE_SIGN_IDENTITY": "iPhone Developer",
                "IPHONEOS_DEPLOYMENT_TARGET": "13.0",
                "OTHER_SWIFT_FLAGS": "",
                "SDKROOT": "iphoneos",
                "SWIFT_COMPILATION_MODE": "wholemodule",
                "SWIFT_OPTIMIZATION_LEVEL": "-O",
                "SWIFT_SWIFT3_OBJC_INFERENCE": "Default",
                "TARGETED_DEVICE_FAMILY": "1",
                "CLANG_CXX_LANGUAGE_STANDARD": "gnu++0x",
                "GCC_C_LANGUAGE_STANDARD": "gnu99",
                "SWIFT_VERSION": ""
            ]
            
            return base.merging(releaseSettings, uniquingKeysWith: { _, release in release })
        case .release_enableServerChange:
            let releaseSettings: [String: SettingValue] = [
                "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": "YES",
                "CODE_SIGN_IDENTITY": "iPhone Developer",
                "IPHONEOS_DEPLOYMENT_TARGET": "13.0",
                "OTHER_SWIFT_FLAGS": "",
                "SDKROOT": "iphoneos",
                "SWIFT_COMPILATION_MODE": "wholemodule",
                "SWIFT_OPTIMIZATION_LEVEL": "-O",
                "SWIFT_SWIFT3_OBJC_INFERENCE": "Default",
                "TARGETED_DEVICE_FAMILY": "1",
                "CLANG_CXX_LANGUAGE_STANDARD": "gnu++0x",
                "GCC_C_LANGUAGE_STANDARD": "gnu99",
                "SWIFT_VERSION": ""
            ]
            
            return base.merging(releaseSettings, uniquingKeysWith: { _, release in release })
        }
    }
    
    private var identifierName: String {
        switch self {
        case .debug:
            return "debug"
        case .release:
            return "release"
        case .release_enableServerChange:
            return "release_enableServerChange"
        }
    }
    
    private func targetSettings(with name: String) -> [String: SettingValue] {
        let base: [String: SettingValue] = [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "CLANG_WARN_STRICT_PROTOTYPES": "YES",
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "CODE_SIGN_STYLE": "Automatic",
            "CURRENT_PROJECT_VERSION": "20090407",
            "DEVELOPMENT_TEAM": "9P5QVDV7V7",
            "INFOPLIST_FILE": "DabangPro/Info.plist",
            "IPHONEOS_DEPLOYMENT_TARGET": "13.0",
            "OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC", "-l\"c++\"", "-l\"sqlite3\"", "-l\"z\""]),
            "LD_RUNPATH_SEARCH_PATHS": .array(["$(inherited)", "@executable_path/Frameworks"]),
            "FRAMEWORK_SEARCH_PATHS": .array(["$(inherited)", "$(PROJECT_DIR)"]),
            "PRODUCT_BUNDLE_IDENTIFIER": "kr.co.station3.DabangPro",
            "PRODUCT_NAME": "$(TARGET_NAME)",
            "PROVISIONING_PROFILE": "",
            "SWIFT_OBJC_BRIDGING_HEADER": "DabangPro/DabangPro-Bridging-Header.h",
            "SWIFT_OPTIMIZATION_LEVEL": "-O",
            "SWIFT_SWIFT3_OBJC_INFERENCE": "Default",
            "SWIFT_VERSION": "5.0",
            "SWIFT_WHOLE_MODULE_OPTIMIZATION": "YES",
            "TARGETED_DEVICE_FAMILY": "1",
            "VALIDATE_WORKSPACE": "YES",
            "OTHER_SWIFT_FLAGS": "",
            "GCC_OPTIMIZATION_LEVEL": "s",
            "ENABLE_PREVIEWS": "NO",
            "CODE_SIGN_ENTITLEMENTS": "DabangPro/DabangPro.entitlements",
        ]
        
        let enableServerChange = "-DSERVERCHANGE"
        
        switch self {
        case .debug:
            let debug: [String: SettingValue] = [
                "DEBUG_INFORMATION_FORMAT": "dwarf",
                "OTHER_SWIFT_FLAGS": .array(["$(inherited)", "\"-D\"", "\"COCOAPODS\"", "-Onone", enableServerChange])
            ]
            return base.merging(debug, uniquingKeysWith: { _, debug in debug })
        case .release:
        let release: [String: SettingValue] = [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
            ]
            
            return base.merging(release, uniquingKeysWith: { _, release in release })
        case .release_enableServerChange:
        let release: [String: SettingValue] = [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "OTHER_SWIFT_FLAGS": .array([enableServerChange])
            ]
            
            return base.merging(release, uniquingKeysWith: { _, release in release })
        }
    }
}

