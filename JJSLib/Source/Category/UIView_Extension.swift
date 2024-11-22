//
//  UIView_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/7/31.
//

import UIKit

public extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

public extension UIView {
    
    /// 尺寸
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = newValue
        }
    }
    
    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = newValue
        }
    }
    
    /// 横坐标
    var x: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }
    
    /// 纵坐标
    var y: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }
    
    /// 右端横坐标
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// 底端纵坐标
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(newValue) {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    /// 中心横坐标
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            center.x = newValue
        }
    }
    
    /// 中心纵坐标
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            center.y = newValue
        }
    }
    
    /// 原点
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set(newValue) {
            frame.origin = newValue
        }
    }
    
    var top: CGFloat {
        get { frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    /// 右上角坐标
    var topRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y)
        }
    }
    
    /// 右下角坐标
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y - height)
        }
    }
    
    /// 左下角坐标
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x, y: newValue.y - height)
        }
    }
}

