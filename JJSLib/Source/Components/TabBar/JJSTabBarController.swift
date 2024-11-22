//
//  JJSTabBarController.swift
//  AniApp
//
//  Created by SharkAnimation on 2023/5/15.
//

import UIKit

open class JJSTabBarController: UITabBarController {
    
    private var _barHeight: CGFloat = 49

    // 获得vc数量
    private var vcCount: Int {
        guard let vcs = viewControllers else { return 0 }
        return vcs.count
    }
    /// 点击回调返回点击第几个
    public typealias DidSelectHandler = ((_ index: Int) -> Void)
    /// tabbar属性,可修改
    public var jjsTabBar = JJSTabBar()
    
    private var didSelectHandler: DidSelectHandler?
    /// 选中VC
    public override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            guard let tabBar = tabBar as? JJSTabBar, let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAt: index, animated: false)
        }
    }
    /// 选中第几个
    public override var selectedIndex: Int {
        willSet {
            guard let tabBar = tabBar as? JJSTabBar else {
                return
            }
            tabBar.select(itemAt: selectedIndex, animated: false)
        }
    }

    public var barHeight: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return _barHeight + view.safeAreaInsets.bottom
            } else {
                return _barHeight
            }
        }
        set {
            _barHeight = newValue
            updateTabBarFrame()
        }
    }
    
    lazy var tabBarAppear: UITabBarAppearance = {
        let appear =  UITabBarAppearance()
        return appear
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setValue(jjsTabBar, forKey: "tabBar")
    }
    
    private func updateTabBarFrame() {
        var tabFrame = tabBar.frame
        tabFrame.size.height = barHeight
        tabFrame.origin.y = view.frame.size.height - barHeight
        tabBar.frame = tabFrame
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarFrame()
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateTabBarFrame()
        jjsTabBar.reloadViews()
    }

    public override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        updateTabBarFrame()
    }

    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return
        }
        if let controller = viewControllers?[idx] {
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: controller)
            didSelectHandler?(idx)
        }
    }

    public func didSelect(_ block: DidSelectHandler?) {
        didSelectHandler = block
    }

    /// 隐藏分隔线
    public func hideTopLine() {
        if #available(iOS 13.0, *) {
            tabBarAppear.shadowImage = UIImage()
            tabBarAppear.backgroundImage = UIImage()
            tabBarAppear.configureWithTransparentBackground()
            tabBar.standardAppearance = tabBarAppear
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppear
            }
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    /// 设置tabbar背景颜色
    public func setTabbarBackColor(_ color: UIColor = .white) {
        jjsTabBar.imageView.backgroundColor = color
    }
    /// 设置tabbar背景图片
    public func setTabbarBackImage(_ image: UIImage?) {
        jjsTabBar.imageView.image = image
    }
}
