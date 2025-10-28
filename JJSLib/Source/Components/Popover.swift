//
//  Popover.swift
//  Popover
//
//  Created by corin8823 on 8/16/15.
//  Copyright (c) 2015 corin8823. All rights reserved.
//

import Foundation
import UIKit

public enum PopoverOption {
    case arrowSize(CGSize)
    case animationIn(TimeInterval)
    case animationOut(TimeInterval)
    case cornerRadius(CGFloat)
    case sideEdge(CGFloat)
    case blackOverlayColor(UIColor)
    case overlayBlur(UIBlurEffect.Style)
    case type(PopoverType)
    case color(UIColor)
    case dismissOnBlackOverlayTap(Bool)
    case showBlackOverlay(Bool)
    case springDamping(CGFloat)
    case initialSpringVelocity(CGFloat)
}

public enum PopoverType: Int {
    case up
    case down
    case center
    case auto
}

open class Popover: UIView {
    // custom property
    open var arrowSize: CGSize = CGSize(width: 16.0, height: 10.0)
    open var animationIn: TimeInterval = 0.6
    open var animationOut: TimeInterval = 0.3
    open var cornerRadius: CGFloat = 6.0
    open var sideEdge: CGFloat = 10.0
    open var popoverType: PopoverType = .down
    open var blackOverlayColor: UIColor = UIColor(white: 0.0, alpha: 0.2)
    open var overlayBlur: UIBlurEffect?
    open var popoverColor: UIColor = UIColor.white
    open var dismissOnBlackOverlayTap: Bool = true
    open var showBlackOverlay: Bool = true
    open var highlightFromView: Bool = false
    open var highlightCornerRadius: CGFloat = 0
    open var springDamping: CGFloat = 0.7
    open var initialSpringVelocity: CGFloat = 3

    // custom closure
    open var willShowHandler: (() -> Void)?
    open var willDismissHandler: (() -> Void)?
    open var didShowHandler: (() -> Void)?
    open var didDismissHandler: (() -> Void)?

    public fileprivate(set) var blackOverlay: UIControl = UIControl()

    fileprivate var containerView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var contentViewFrame: CGRect!
    fileprivate var arrowShowPoint: CGPoint!

    public init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        accessibilityViewIsModal = true
    }

    public init(showHandler: (() -> Void)?, dismissHandler: (() -> Void)?) {
        super.init(frame: .zero)
        backgroundColor = .clear
        didShowHandler = showHandler
        didDismissHandler = dismissHandler
        accessibilityViewIsModal = true
    }

    public init(options: [PopoverOption]?, showHandler: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setOptions(options)
        didShowHandler = showHandler
        didDismissHandler = dismissHandler
        accessibilityViewIsModal = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: bounds.width, height: bounds.height - arrowSize.height)
    }

    /// 不带箭头显示在屏幕中央
    open func showAsDialog(_ contentView: UIView) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        showAsDialog(contentView, inView: rootView)
    }

    /// 不带箭头显示在指定的 inView 中央
    open func showAsDialog(_ contentView: UIView, inView: UIView) {
        arrowSize = .zero
        popoverType = .center
        let point = CGPoint(
            x: inView.center.x,
            y: inView.center.y - contentView.frame.height / 2
        )
        show(contentView, point: point, inView: inView)
    }

    open func show(_ contentView: UIView, fromView: UIView, offset: CGPoint = .zero) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        show(contentView, fromView: fromView, inView: rootView, offset: offset)
    }

    open func show(_ contentView: UIView, fromView: UIView, inView: UIView, offset: CGPoint = .zero) {
        let point: CGPoint

        if popoverType == .auto {
            if let point = fromView.superview?.convert(fromView.frame.origin, to: nil),
                point.y + fromView.frame.height + arrowSize.height + contentView.frame.height > inView.frame.height {
                popoverType = .up
            } else {
                popoverType = .down
            }
        }

        switch popoverType {
        case .up:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y
                ), from: fromView.superview
            )
        case .down, .auto, .center:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y + fromView.frame.size.height
                ), from: fromView.superview
            )
        }

        if highlightFromView {
            createHighlightLayer(fromView: fromView, inView: inView)
        }

        show(contentView, point: CGPoint(x: point.x + offset.x, y: point.y + offset.y), inView: inView)
    }

    open func show(_ contentView: UIView, point: CGPoint) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        show(contentView, point: point, inView: rootView)
    }

    open func show(_ contentView: UIView, point: CGPoint, inView: UIView) {
        if dismissOnBlackOverlayTap || showBlackOverlay {
            blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blackOverlay.frame = inView.bounds
            inView.addSubview(blackOverlay)

            if showBlackOverlay {
                if let overlayBlur = self.overlayBlur {
                    let effectView = UIVisualEffectView(effect: overlayBlur)
                    effectView.frame = blackOverlay.bounds
                    effectView.isUserInteractionEnabled = false
                    blackOverlay.addSubview(effectView)
                } else {
                    if !highlightFromView {
                        blackOverlay.backgroundColor = blackOverlayColor
                    }
                    blackOverlay.alpha = 0
                }
            }

            if dismissOnBlackOverlayTap {
                blackOverlay.addTarget(self, action: #selector(Popover.dismiss), for: .touchUpInside)
            }
        }

        containerView = inView
        self.contentView = contentView
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.masksToBounds = true
        arrowShowPoint = point
        show()
    }

    override open func accessibilityPerformEscape() -> Bool {
        dismiss()
        return true
    }

    @objc open func dismiss() {
        if superview != nil {
            willDismissHandler?()
            UIView.animate(
                withDuration: animationOut,
                delay: 0,
                options: UIView.AnimationOptions(),
                animations: {
                    self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                    self.blackOverlay.alpha = 0
                }
            ) { _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
                self.transform = CGAffineTransform.identity
                self.didDismissHandler?()
            }
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let arrow = UIBezierPath()
        let color = popoverColor
        let arrowPoint = containerView.convert(arrowShowPoint, to: self)
        switch popoverType {
        case .up:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: bounds.height))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x - arrowSize.width * 0.5,
                    y: isCornerLeftArrow ? arrowSize.height : bounds.height - arrowSize.height
                )
            )

            arrow.addLine(to: CGPoint(x: cornerRadius, y: bounds.height - arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: cornerRadius,
                    y: bounds.height - arrowSize.height - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(90),
                endAngle: radians(180),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: 0, y: cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: cornerRadius,
                    y: cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(180),
                endAngle: radians(270),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: bounds.width - cornerRadius, y: 0))
            arrow.addArc(
                withCenter: CGPoint(
                    x: bounds.width - cornerRadius,
                    y: cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(270),
                endAngle: radians(0),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - arrowSize.height - cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: bounds.width - cornerRadius,
                    y: bounds.height - arrowSize.height - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(0),
                endAngle: radians(90),
                clockwise: true
            )

            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + arrowSize.width * 0.5,
                    y: isCornerRightArrow ? arrowSize.height : bounds.height - arrowSize.height
                )
            )

        case .down, .auto, .center:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + arrowSize.width * 0.5,
                    y: isCornerRightArrow ? arrowSize.height + bounds.height : arrowSize.height
                )
            )

            arrow.addLine(to: CGPoint(x: bounds.width - cornerRadius, y: arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: bounds.width - cornerRadius,
                    y: arrowSize.height + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(270.0),
                endAngle: radians(0),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: bounds.width - cornerRadius,
                    y: bounds.height - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(0),
                endAngle: radians(90),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: 0, y: bounds.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: cornerRadius,
                    y: bounds.height - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(90),
                endAngle: radians(180),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(x: 0, y: arrowSize.height + cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: cornerRadius,
                    y: arrowSize.height + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: radians(180),
                endAngle: radians(270),
                clockwise: true
            )

            arrow.addLine(to: CGPoint(
                x: arrowPoint.x - arrowSize.width * 0.5,
                y: isCornerLeftArrow ? arrowSize.height + bounds.height : arrowSize.height
            ))
        }

        color.setFill()
        arrow.fill()
    }
}

private extension Popover {
    func setOptions(_ options: [PopoverOption]?) {
        if let options = options {
            for option in options {
                switch option {
                case let .arrowSize(value):
                    arrowSize = value
                case let .animationIn(value):
                    animationIn = value
                case let .animationOut(value):
                    animationOut = value
                case let .cornerRadius(value):
                    cornerRadius = value
                case let .sideEdge(value):
                    sideEdge = value
                case let .blackOverlayColor(value):
                    blackOverlayColor = value
                case let .overlayBlur(style):
                    overlayBlur = UIBlurEffect(style: style)
                case let .type(value):
                    popoverType = value
                case let .color(value):
                    popoverColor = value
                case let .dismissOnBlackOverlayTap(value):
                    dismissOnBlackOverlayTap = value
                case let .showBlackOverlay(value):
                    showBlackOverlay = value
                case let .springDamping(value):
                    springDamping = value
                case let .initialSpringVelocity(value):
                    initialSpringVelocity = value
                }
            }
        }
    }

    func create() {
        var frame = contentView.frame
        frame.origin.x = arrowShowPoint.x - frame.size.width * 0.5

        var sideEdge: CGFloat = 0.0
        if frame.size.width < containerView.frame.size.width {
            sideEdge = self.sideEdge
        }

        let outerSideEdge = frame.maxX - containerView.bounds.size.width
        if outerSideEdge > 0 {
            frame.origin.x -= (outerSideEdge + sideEdge)
        } else {
            if frame.minX < 0 {
                frame.origin.x += abs(frame.minX) + sideEdge
            }
        }
        self.frame = frame

        let arrowPoint = containerView.convert(arrowShowPoint, to: self)
        var anchorPoint: CGPoint
        switch popoverType {
        case .up:
            frame.origin.y = arrowShowPoint.y - frame.height - arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
        case .down, .auto:
            frame.origin.y = arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
        case .center:
            frame.origin.y = arrowShowPoint.y
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }

        let lastAnchor = layer.anchorPoint
        layer.anchorPoint = anchorPoint
        let x = layer.position.x + (anchorPoint.x - lastAnchor.x) * layer.bounds.size.width
        let y = layer.position.y + (anchorPoint.y - lastAnchor.y) * layer.bounds.size.height
        layer.position = CGPoint(x: x, y: y)

        frame.size.height += arrowSize.height
        self.frame = frame
    }

    func createHighlightLayer(fromView: UIView, inView: UIView) {
        let path = UIBezierPath(rect: inView.bounds)
        let highlightRect = inView.convert(fromView.frame, from: fromView.superview)
        let highlightPath = UIBezierPath(roundedRect: highlightRect, cornerRadius: highlightCornerRadius)
        path.append(highlightPath)
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = blackOverlayColor.cgColor
        blackOverlay.layer.addSublayer(fillLayer)
    }

    func show() {
        setNeedsDisplay()
        switch popoverType {
        case .up:
            contentView.frame.origin.y = 0.0
        case .down, .auto, .center:
            contentView.frame.origin.y = arrowSize.height
        }
        addSubview(contentView)
        containerView.addSubview(self)

        create()
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        willShowHandler?()
        UIView.animate(
            withDuration: animationIn,
            delay: 0,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: initialSpringVelocity,
            options: UIView.AnimationOptions(),
            animations: {
                self.transform = CGAffineTransform.identity
            }
        ) { _ in
            self.didShowHandler?()
        }
        UIView.animate(
            withDuration: animationIn / 3,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.blackOverlay.alpha = 1
            }, completion: nil
        )
    }

    var isCornerLeftArrow: Bool {
        return arrowShowPoint.x == frame.origin.x
    }

    var isCornerRightArrow: Bool {
        return arrowShowPoint.x == frame.origin.x + bounds.width
    }

    func radians(_ degrees: CGFloat) -> CGFloat {
        return CGFloat.pi * degrees / 180
    }
}
