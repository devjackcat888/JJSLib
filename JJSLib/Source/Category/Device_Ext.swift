//
//  Device_Ext.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/23.
//

import UIKit

public extension UIDevice {
    var jjs_isChineseLanguage: Bool {
        if let languateCode = Locale.preferredLanguages.first {
            if languateCode == "zh-Hant" ||
                languateCode.hasPrefix("zh-Hant") ||
                languateCode.hasPrefix("yue-Hant") ||
                languateCode == "zh-HK" ||
                languateCode == "zh-TW" ||
                languateCode == "zh-Hans" ||
                languateCode.hasPrefix("yue-Hans") ||
                languateCode.hasPrefix("zh-Hans") {
                return true
            }
        }
        return false
    }
}
