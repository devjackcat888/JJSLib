//
//  TouchTroughView.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/7/31.
//

import UIKit

open class TouchThroughView: UIView {
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if view.alpha > 0, !view.isHidden, view.isUserInteractionEnabled, view.point(inside: convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }
}
