//
//  UIView_Layout.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/5.
//

import UIKit

public extension UIView {
    
    var app_left: CGFloat {
        get { frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var app_top: CGFloat {
        get { frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var app_right: CGFloat {
        get { frame.origin.x + frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    var app_bottom: CGFloat {
        get { frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    var app_centerX: CGFloat {
        get { center.x }
        set { center = CGPoint(x: newValue, y: center.y) }
    }
    
    var app_centerY: CGFloat {
        get { center.y }
        set { center = CGPoint(x: center.x, y: newValue) }
    }

    var app_width: CGFloat {
        get { frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var app_height: CGFloat {
        get { frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
}
