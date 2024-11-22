//
//  Color_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/4/27.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
public extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, opacity: a)
    }

    init(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            self.init(r: 0, g: 0, b: 0)
        }
    }

    /// 随机色
    static var random: UIColor {
        let red = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue = CGFloat.random(in: 0...255)
        return UIColor(r: red, g: green, b: blue)
    }
}

public extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    /// 渐变色
    class func jjs_gradientColor(size: CGSize, colors: [UIColor], direction: gradientColorDirection = .left2Right) -> UIColor? {
        if let image = UIImage.jjs_gradientColor(size: size, colors: colors, direction: direction) {
            return UIColor(patternImage: image)
        }
        return UIColor.black
    }
    /// 渐变色
    class func jjs_gradientColor(size: CGSize, colors: [String], direction: gradientColorDirection = .left2Right) -> UIColor? {
        return jjs_gradientColor(size: size, colors: colors.map{ UIColor($0) }, direction: direction)
    }
    
    /// 简化RGB颜色写法
    class func RGBA(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }

    var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }

    var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }

    var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }

    var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }

    /// 最小饱和度值
    func color(_ minSaturation: CGFloat) -> UIColor {
      var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
      getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

      return saturation < minSaturation
        ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
       : self
    }

    /// 随机色
    static var random: UIColor {
        let red = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue = CGFloat.random(in: 0...255)
        return UIColor(r: red, g: green, b: blue)
    }
    
    func jjs_setAlpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}
