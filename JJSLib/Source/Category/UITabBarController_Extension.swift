//
//  UITabBarController_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/15.
//

import UIKit

public extension UITabBarController {
    @discardableResult
    public func jjs_clearStyle() -> Self{
        if #available(iOS 13.0, *) {
            let tabBarAppear =  UITabBarAppearance()
            tabBarAppear.shadowImage = UIImage()
            tabBarAppear.backgroundImage = UIImage()
            tabBarAppear.configureWithTransparentBackground()
            tabBar.standardAppearance = tabBarAppear
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
        return self
    }
}
