//
//  UIFont_Ext.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/16.
//

import UIKit

public extension UIFont {
    enum Blod {
        case regular
        case medium
        case light
        case semibold
        case thin
    }

    static func pingFang(_ blod: UIFont.Blod = .regular, size: CGFloat) -> UIFont {
        var font: UIFont?
        switch blod {
        case .regular:
            font = UIFont(name: "PingFangSC-Regular", size: size)
        case .medium:
            font = UIFont(name: "PingFangSC-Medium", size: size)
        case .light:
            font = UIFont(name: "PingFangSC-Light", size: size)
        case .semibold:
            font = UIFont(name: "PingFangSC-Semibold", size: size)
        case .thin:
            font = UIFont(name: "PingFangSC-Thin", size: size)
        }

        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func dinAlternate(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}

public extension String {

    func jjs_localizable() -> Self {
        return NSLocalizedString(self, comment: "")
    }
}
