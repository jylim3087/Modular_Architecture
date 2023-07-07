//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 임주영 on 2023/06/27.
//

import Foundation
import ProjectDescription

public struct Dependency {
    
    public static var packages: [Package] {
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
            .package(url: "https://github.com/airbnb/lottie-ios.git",                    .exact("3.2.3")),
            .package(url: "https://github.com/hkellaway/Gloss.git",                       .exact("3.2.1")),
        ]
    }

}

