//
//  WatermarkView.swift
//  CamScanner
//
//  Created by SharkAnimation on 2023/7/31.
//

import UIKit

public class WatermarkView: UIView {
    public var watermark: String  = "" {
       didSet {
           if watermark.isEmpty {
               self.isHidden = true
               return
           }
           self.isHidden = false
         // 水印文字有更新，应该重新绘制
           setNeedsDisplay()
       }
   }
   
   /// 时间格式化
   private var dateFormater = DateFormatter()

   override init(frame: CGRect) {
       super.init(frame: frame)
       isHidden = true
       dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
     // 让背景透明，水印视图不能遮挡下面的其他页面
       backgroundColor = .clear
     // 设置定时器，每隔一段时间刷新水印上的时间，因为水印会伴随整个APP的生命周期，所以没有考虑回收timer。
//       Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
//           self?.setNeedsDisplay()
//       })
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
    public override func layoutSubviews() {
       super.layoutSubviews()
         // 布局有变动，更新水印
       self.setNeedsDisplay()
   }

     // 绘制水印
    public override func draw(_ rect: CGRect) {
     // 获取上下文对象
       let context = UIGraphicsGetCurrentContext()
     // 保存上下文状态
       context?.saveGState()
       defer {
         // 绘制完成后，恢复状态
           context?.restoreGState()
       }
         // 设置填充颜色为透明
       UIColor.clear.setFill()
         // 用透明色清除整个视图，重新绘制内容
       context?.clear(rect)
         // 设置混合模式为柔光，能更好的让水印文字与内容混合，减少水印的突兀感。
       context?.setBlendMode(.softLight)
       // 平移和旋转画布，目的是绘制倾斜的水印
       context?.translateBy(x: rect.width / 2, y: rect.height / 2)
       context?.rotate(by: -(CGFloat.pi / 4))
       context?.translateBy(x: -rect.width / 2, y: -rect.height / 2)

         // 构造水印内容
       let date = Date()
       let textAttribute:[NSAttributedString.Key : Any] =  [.foregroundColor:UIColor.black.withAlphaComponent(0.1),
                                                            .font:UIFont.systemFont(ofSize: 15)]
//       let text = "\(watermark) \(dateFormater.string(from: date))" as NSString
       let text = "\(watermark)" as NSString
       let textSize = text.boundingRect(with: CGSize(width: .max, height: .max), options: .usesLineFragmentOrigin, attributes: textAttribute, context: nil)
         // 每个水印的横向距离
       let stepX: CGFloat = textSize.width + 20
       // 每个水印的纵向距离
       let stepY: CGFloat = textSize.height + 20
         
       let w = (sqrt(pow(rect.width, 2)+pow(rect.height, 2)))
       var y: CGFloat = -w
         // 让相邻两行的水印交错排列
       var doOffset = false
         // 循环绘制水印，充满屏幕，之所以是两倍宽度，是为了让屏幕边缘也有一些被裁切了一般的水印，让水印填充得更满
       while y < 2*w {
           defer {
               y += stepY
               doOffset.toggle()
           }
           var x: CGFloat = -2*w
           if doOffset {
               x -= stepX/2
           }
           while x < w {
               defer { x += stepX }
               let p = CGPoint(x: x, y: y)
                 // 绘制文字
               text.draw(at: p, withAttributes:textAttribute)
           }
       }
   }
}
