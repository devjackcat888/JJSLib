//
//  UIApplication_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/4/27.
//

import SwiftUI

@available(iOS 13.0, *)
extension UIApplication {
    public var appKeyWindow: UIWindow? {
//        connectedScenes
//            .compactMap {
//                $0 as? UIWindowScene
//            }
//            .flatMap {
//                $0.windows
//            }
//            .first {
//                $0.isKeyWindow
//            }
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        return window!
    }
}

public extension UIApplication {
    class func topViewController() -> UIViewController? {
        var window: UIWindow?
        if let keyWindow = UIApplication.shared.keyWindow, keyWindow.bounds == UIScreen.main.bounds {
            window = keyWindow
        } else {
            window = UIApplication.shared.windows.last(where: { $0.bounds == UIScreen.main.bounds && !$0.isHidden && $0.alpha > 0 })
        }
        return topViewController(base: window?.rootViewController)
    }

    class func topViewController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    class func visibleViewControllersStack() -> [UIViewController] {
        return UIApplication.shared.windows.reversed().flatMap {
            self.visibleViewControllersStack(base: $0.rootViewController)
        }
    }

    private class func visibleViewControllersStack(base: UIViewController?) -> [UIViewController] {
        var stack = [UIViewController]()
        func appendViewController(_ base: UIViewController) {
            stack.insert(base, at: 0)
            if base.shouldRecursionFindChild {
                base.children.forEach {
                    appendViewController($0)
                }
            }
        }

        func recursionTopViewController(base: UIViewController?) {
            guard let base = base else { return }
            if let nav = base as? UINavigationController {
                stack.insert(nav, at: 0)
                nav.viewControllers.forEach { vc in
                    appendViewController(vc)
                }
                recursionTopViewController(base: nav.topViewController)
                return
            }
            if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                stack.insert(tab, at: 0)
                appendViewController(selected)
                recursionTopViewController(base: selected)
                return
            }
            if let presented = base.presentedViewController {
                appendViewController(presented)
                recursionTopViewController(base: presented)
                return
            }
        }

        recursionTopViewController(base: base)

        return stack
    }

    class func firstVisibleViewController<T: UIViewController>(type: T.Type) -> T? {
        return UIApplication.visibleViewControllersStack().first(where: { $0 is T }) as? T
    }

    class func lastVisibleViewController<T: UIViewController>(type: T.Type) -> T? {
        return UIApplication.visibleViewControllersStack().last(where: { $0 is T }) as? T
    }
}

private extension UIViewController {
    var shouldRecursionFindChild: Bool {
        if viewIfLoaded?.isHidden ?? true {
            return false
        }
        if viewIfLoaded?.alpha ?? 0 <= 0 {
            return false
        }
        if self is UINavigationController {
            return false
        }
        if self is UITabBarController {
            return false
        }
        return true
    }
}
