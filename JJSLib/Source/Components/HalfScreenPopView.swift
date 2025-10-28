//
//  AniHalfScreenPopView.swift
//  App
//
//  Created by SharkAnimation on 2023/9/12.
//

import UIKit

open class HalfScreenPopView: UIView {
    
    public enum Direction {
        case bottomToTop
        case topTopBottom
    }
    
    private(set) open var contentView: TouchThroughView!
    private(set) var closeButton: UIControl!
    private(set) var bgMaskView: UIView! // 半透明蒙版
    
    open var contentHeight: CGFloat = 200
    // 内容从下往上飘入
    open var direction: Direction = .bottomToTop
    open var maskColor: UIColor = UIColor.black.jjs_setAlpha(0.3) {
        didSet {
            bgMaskView.backgroundColor = maskColor
        }
    }
    
    private var ScreenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var ScreenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        bgMaskView = UIView()
            .jjs_setAlpha(0)
            .jjs_setUserInteractionEnabled(false)
            .jjs_setBackgroundColor(UIColor.black.jjs_setAlpha(0.3))
            .jjs_layout(superView: self, { make in
                make.left.top.right.bottom.equalTo(0)
            })
        
        closeButton = UIControl()
            .jjs_clearBackgroundColor()
            .jjs_layout(superView: self, { make in
                make.left.top.right.bottom.equalTo(0)
            })
            .jjs_clickBlock { [weak self] in
                self?.hideAni()
            }
        
        jjs_clearBackgroundColor()
        contentView = TouchThroughView()
            .jjs_setBackgroundColor(.white)
            .jjs_layout(superView: self, CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: contentHeight))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func showAni(hostView: UIView? = nil) {
        let parentView = hostView ?? UIApplication.topViewController()?.view
        guard let topView = parentView else {
            return
        }
        self.frame = topView.bounds
        topView.addSubview(self)
        
        contentView.app_height = contentHeight
        bgMaskView.alpha = 0
        
        if self.direction == .topTopBottom {
            self.contentView.app_top = -self.contentHeight
        }
        
        UIView.animate(withDuration: 0.25) {
            self.bgMaskView.alpha = 1
            if self.direction == .bottomToTop {
                self.contentView.app_top = self.ScreenHeight - self.contentHeight
            } else {
                self.contentView.app_top = 0
            }
        }
        
    }
    open func hideAni() {
        UIView.animate(withDuration: 0.25) {
            self.bgMaskView.alpha = 0
            if self.direction == .bottomToTop {
                self.contentView.app_top = self.ScreenHeight
            } else {
                self.contentView.app_top = -self.ScreenHeight
            }
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
