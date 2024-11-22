//
//  JJSViewController.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/15.
//

import UIKit

open class JJSViewController: UIViewController {
    
    /// 是否隐藏NavBar
    public var hiddenNavBar = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.jjs_setBackgroundColor(.white)
        clearNavBarDefaultStyle()
        configUI()
        configSignal()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hiddenNavBar, animated: false)
    }

    open func configUI() {
        fatalError("subclass must override configUI method")
    }
    open func configSignal() {
        fatalError("subclass must override configSignal method")
    }
    
    /// 清除导航栏默认样式
    open func clearNavBarDefaultStyle() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
