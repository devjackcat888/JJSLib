//
//  UITabBarItem_Extension.swift
//  AniApp
//
//  Created by SharkAnimation on 2023/5/15.
//

import UIKit

//private var KLottieName: Int = 0x2020_11_01
private var kTitleFont: Int = 0x2020_11_02
private var kTitleColor: Int = 0x2020_11_03
private var kTitleSelectedColor: Int = 0x2020_11_04
private var kIconColor: Int = 0x2020_11_05
private var kIconSelectedColor: Int = 0x2020_11_06
private var kRenderingMode: Int = 0x2020_11_09
//private var KLottieSpeed: Int = 0x2020_11_10

public extension UITabBarItem {

    /// lottie动画文件名称,可不添加后最
//    @IBInspectable public var lottieName: String? {
//        get {
//            return objc_getAssociatedObject(self, &KLottieName) as? String
//        }
//        set {
//            objc_setAssociatedObject(self, &KLottieName, newValue, .OBJC_ASSOCIATION_RETAIN)
//            image = UIImage()
//        }
//    }
//    /// lottie动画执行速度
//    public var lottieAnimationSpeed: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &KLottieSpeed) as? CGFloat
//        }
//        set {
//            objc_setAssociatedObject(self, &KLottieSpeed, newValue, .OBJC_ASSOCIATION_RETAIN)
//            image = UIImage()
//        }
//    }
//    /// 方便XIB修改动画执行速度
//    @IBInspectable public var lottieSpeed: CGFloat {
//        set {
//            lottieAnimationSpeed = newValue
//        }
//        get {
//            return lottieAnimationSpeed ?? 1.0
//        }
//    }
    /// 未选中字体颜色
    public var titleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &kTitleColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &kTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    /// 选中字体颜色
    var selectedTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &kTitleSelectedColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &kTitleSelectedColor, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    /// 未选中图片颜色(图片imageRenderingMode=true模式下可用)
    var iconColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &kIconColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &kIconColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            renderingMode = true
        }
    }
    /// 选中图片颜色(图片imageRenderingMode=true模式下可用)
    var selectedIconColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &kIconSelectedColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &kIconSelectedColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            renderingMode = true
        }
    }
    /// 字体大小
    var titleFontSize: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &kTitleFont) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &kTitleFont, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    /// XIB修改字体大小
    var fontSize: CGFloat {
        set {
            titleFontSize = newValue
        }
        get {
            return titleFontSize ?? 14.0
        }
    }

    /// 图片模式---是否通透
    var imageRenderingMode: Bool? {
        get {
            return objc_getAssociatedObject(self, &kRenderingMode) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &kRenderingMode, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    /// XIB修改图片模式
    var renderingMode: Bool {
        set {
            imageRenderingMode = newValue
        }
        get {
            return imageRenderingMode ?? false
        }
    }
}
