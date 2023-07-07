//
//  VersionUtil.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 6. 19..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import Gloss
import Share

public struct VersionUtil {
    public static func currentVersionIsGreatOrEqualThan(version :String) -> Bool {
        let compareVersionStrings = version.components(separatedBy: ".")
        let versionStrings = appVersion.components(separatedBy: ".")
        let maxCount = min(compareVersionStrings.count, versionStrings.count)
        for idx in 0 ..< maxCount {
            let compareString = compareVersionStrings[idx]
            let versionString = versionStrings[idx]
            guard let compare = Int(compareString) else { return true }
            guard let version = Int(versionString) else { return true }
            if version > compare { return true }
            if compare > version { return false }
        }
        
        return (versionStrings.count >= compareVersionStrings.count)
    }
    
    public static var appVersion : String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "3.0.0" }
        return version
    }
    
    public static var buildVersion : String {
        guard let version = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String else { return "3.0.0" }
        return version
    }
    
    public static func showAppStoreAlert() {
        Alert(title: "업데이트가 필요합니다.", message: "최신 버전으로 업데이트해주세요.")
        .addAction("업데이트 하기", style: .default) { (_) in
            let url = "https://itunes.apple.com/kr/app/id814840066"
            
            guard let appUrl = URL(string: url) else { return }
            
            appUrl.open()
        }.show()
    }
}
