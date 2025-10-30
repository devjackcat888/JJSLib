//
//  Color_Extension.swift
//  JJSLib
//
//  Created by JJS on 2023/4/27.
//

import UIKit

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
    
    static func hx(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 移除可能存在的 # 前缀
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // 处理缩写格式（3位或4位）
        if [3, 4].contains(hexString.count) {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        
        // 验证有效长度
        guard [6, 8].contains(hexString.count) else {
            print("❌❌❌ 颜色16进制值错误")
            return .clear
        }
            
        // 转换为 RGB/RGBA 数值
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 6 {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
        } else {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
        }
    }
}
