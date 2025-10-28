//
//  DragableView.swift
//  GoodMood
//
//  Created by Zhuanz密码0000 on 2025/10/28.
//

import UIKit

open class DragableView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupPanGesture()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPanGesture() {
           // 添加拖动手势识别器[1,6](@ref)
           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
           self.addGestureRecognizer(panGesture)
           
           // 启用用户交互
           self.isUserInteractionEnabled = true
       }
       
       @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
           // 获取父视图的边界[3](@ref)
           guard let superview = self.superview else { return }
           
           // 获取手势的位移[1](@ref)
           let translation = gesture.translation(in: superview)
           
           switch gesture.state {
           case .began, .changed:
               // 计算新的中心点[1](@ref)
               var newCenter = CGPoint(
                   x: self.center.x + translation.x,
                   y: self.center.y + translation.y
               )
               
               // 边界判断，确保视图不会拖出父容器[1](@ref)
               let halfWidth = self.bounds.width / 2
               let halfHeight = self.bounds.height / 2
               let superviewWidth = superview.bounds.width
               let superviewHeight = superview.bounds.height
               
               // 限制x坐标范围
               newCenter.x = max(halfWidth, newCenter.x)
               newCenter.x = min(superviewWidth - halfWidth, newCenter.x)
               
               // 限制y坐标范围
               newCenter.y = max(halfHeight, newCenter.y)
               newCenter.y = min(superviewHeight - halfHeight, newCenter.y)
               
               // 应用新的中心点
               self.center = newCenter
               
               // 重置位移
               gesture.setTranslation(.zero, in: superview)
               
           case .ended, .cancelled:
               // 拖动结束时的动画效果（可选）
               UIView.animate(withDuration: 0.3) {
                   self.transform = CGAffineTransform.identity
               }
               
           default:
               break
           }
       }

}
