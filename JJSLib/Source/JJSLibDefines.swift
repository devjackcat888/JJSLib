//
//  JCSSwiftDefines.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/4/29.
//

import UIKit

// MARK: - 屏幕

/// 当前屏幕状态 宽度
public let ScreenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
/// 当前屏幕状态 高度
public let ScreenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

/// 当前屏幕状态 宽度按照4.7寸 375 屏幕比例 例如 30*FitWidth即可
public let FitWidth = ScreenWidth / 375
/// 当前屏幕状态 高度按照4.7寸 667 屏幕比例 例如 30*FitHeight即可
public let FitHeight = ScreenHeight / 667
/// 当前屏幕比例
public let ScreenScale = UIScreen.main.scale
/// 画线宽度 不同分辨率都是一像素
public let OnePixelHeight = CGFloat(ScreenScale >= 1 ? 1/ScreenScale: 1)

/// 信号栏高度
/// - Returns: 高度
public func StatusBarHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        return getWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}
/// 获取当前设备window用于判断尺寸
public func getWindow() -> UIWindow? {
    return UIApplication.shared.appKeyWindow
}

public func getSafeAreaInsets() -> UIEdgeInsets {
    return getWindow()?.safeAreaInsets ?? UIEdgeInsets()
}

/// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度
public func NavBarHeight() -> CGFloat {
    return UINavigationController().navigationBar.frame.size.height
}

/// 获取屏幕导航栏+信号栏总高度
public let NavAndStatusHeight = StatusBarHeight() + NavBarHeight()
/// 获取刘海屏底部home键高度,普通屏为0
public let BottomHomeHeight = getSafeAreaInsets().bottom

/// TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度
public func TabbarHeight() -> CGFloat {
    return UITabBarController().tabBar.frame.size.height
}
// 刘海屏=TabBar高度+Home键高度, 普通屏幕为TabBar高度
public let TabBarHeight = TabbarHeight() + BottomHomeHeight

/// 根据屏幕自适应字体参数 16*FontFit
public let FontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375

/// App 显示名称
public var AppDisplayName: String? {
    return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}

public var AppName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// app 的bundleid
public var AppBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// build号
public var AppBuildNumber: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
}

/// app版本号
public var AppVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
