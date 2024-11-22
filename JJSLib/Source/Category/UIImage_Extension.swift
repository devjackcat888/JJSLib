//
//  UIImage_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/9.
//

import UIKit

public enum gradientColorDirection {
    /// 从左到右
    case left2Right
    /// 从上到下
    case top2Bottom
    /// 从左上角到右下角
    case leftTop2RightBottom
}

public extension UIImage {
    
    class func jjs_gradientColor(size: CGSize, colors: [String], direction: gradientColorDirection = .left2Right) -> UIImage? {
        return jjs_gradientColor(size: size, colors: colors.map { UIColor($0) }, direction: direction)
    }
    
    /// 渐变色
    class func jjs_gradientColor(size: CGSize, colors: [UIColor], direction: gradientColorDirection = .left2Right) -> UIImage? {
        
        if colors.count < 2 {
            return nil
        }
        
        var _colors = [CGColor]()
        colors.forEach { color in
            _colors.append(color.cgColor)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, size.width, size.height) // 设置渐变色的大小
        gradientLayer.colors = _colors // 设置渐变色的颜色数组
        
        switch direction {
            case .left2Right:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .top2Bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            case .leftTop2RightBottom:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, gradientLayer.isOpaque, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    convenience init(jjs_renderColor:String, size: CGSize) {
        self.init(jjs_renderColor: UIColor(jjs_renderColor), size: size)
        
    }
    convenience init(jjs_renderColor:UIColor?, size: CGSize) {
        self.init()
        let color = jjs_renderColor ?? .black
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        self.init(cgImage: image.cgImage!)
    }
    
    /// 水平翻转
    func jjs_vMirror() -> UIImage? {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: self.size.height)
        transform = transform.scaledBy(x: 1, y: -1)
        return _redrawImage(transform)
    }
    /// 垂直翻转
    func jjs_hMirror() -> UIImage? {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: self.size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
        return _redrawImage(transform)
    }
    
    func jjs_fixOrientation() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        return _redrawImage(transform)
    }
    
    private func _redrawImage(_ transform: CGAffineTransform) -> UIImage? {
        if let cgImage = self.cgImage,
           let colorSpace = cgImage.colorSpace {
            
           let ctx = CGContext(data: nil,
                               width: Int(self.size.width),
                               height: Int(self.size.height),
                               bitsPerComponent: cgImage.bitsPerComponent,
                               bytesPerRow: 0,
                               space: colorSpace,
                               bitmapInfo: cgImage.bitmapInfo.rawValue)
            
            guard let ctx else {
                return nil
            }
            
            ctx.concatenate(transform)
            
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }
            
            if let cgimg = ctx.makeImage() {
                let img = UIImage(cgImage: cgimg)
                return img
            }
        }
        return nil
    }

    
    /// 对图片进行旋转
    /// - Parameter degrees: 直接传入度数
    func jjs_rotate(byDegrees degrees: CGFloat, targetSize: CGSize? = nil) -> UIImage {
        let radians = degrees * .pi / 180.0
        let newSize = rotatedSize(withRadians: radians)
           
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: newSize.width / 2.0, y: newSize.height / 2.0)
        context.rotate(by: radians)

        self.draw(in: CGRect(x: -self.size.width / 2.0, y: -self.size.height / 2.0, width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage ?? UIImage()
    }
    
    private func rotatedSize(withRadians radians: CGFloat) -> CGSize {
        let rotatedRect = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        return CGSize(width: abs(rotatedRect.width), height: abs(rotatedRect.height))
    }
    
    /// 检测图片内的矩形边框(左上、右上、右下、左下)
    func jjs_detectRectangle() -> (leftTop: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint)? {
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: detectorOptions) else {
            fatalError("Failed to create CIDetector.")
        }
        // 获取矩形区域数组, 这里一定要先将图片垂直翻转后再检测
        if let cgImage = self.jjs_vMirror()?.cgImage {
            let image = CIImage(cgImage: cgImage)
            let rectangles = detector.features(in: image)
            if let rectangle = rectangles.first as? CIRectangleFeature {
//                return (rectangle.topLeft,rectangle.topRight,rectangle.bottomRight,rectangle.bottomLeft)
                return (rectangle.bottomLeft,rectangle.bottomRight,rectangle.topRight,rectangle.topLeft)
            }
        }
        return nil
    }
    
    /// 透视校正裁剪
    func jjs_perspectiveCorp(points: [CGPoint]) -> UIImage? {
        
        guard points.count == 4, let image = self.jjs_vMirror() else {
            return nil
        }

        // Calculate the size of the cropped image
//        let minX = points.min(by: { $0.x < $1.x })!.x
//        let maxX = points.max(by: { $0.x < $1.x })!.x
//        let minY = points.min(by: { $0.y < $1.y })!.y
//        let maxY = points.max(by: { $0.y < $1.y })!.y
//        let croppedWidth = maxX - minX
//        let croppedHeight = maxY - minY
//
//        // Calculate the scale factor for resizing
//        var scale: CGFloat = 1.0
//        if croppedWidth > croppedHeight {
//            scale = targetSize.width / croppedWidth
//        } else {
//            scale = targetSize.height / croppedHeight
//        }

        // Create a CIImage from the UIImage
        guard let ciImage = CIImage(image: image) else {
            return nil
        }

        // Create four points representing the corners of the cropped image
        let topLeft = CIVector(x: points[0].x, y: points[0].y)
            let topRight = CIVector(x: points[1].x, y: points[1].y)
            let bottomRight = CIVector(x: points[2].x, y: points[2].y)
            let bottomLeft = CIVector(x: points[3].x, y: points[3].y)

        // Create a CIFilter for perspective correction
        let perspectiveCorrectionFilter = CIFilter(name: "CIPerspectiveCorrection")!
        perspectiveCorrectionFilter.setValue(ciImage, forKey: kCIInputImageKey)
        perspectiveCorrectionFilter.setValue(topLeft, forKey: "inputTopLeft")
        perspectiveCorrectionFilter.setValue(topRight, forKey: "inputTopRight")
        perspectiveCorrectionFilter.setValue(bottomRight, forKey: "inputBottomRight")
        perspectiveCorrectionFilter.setValue(bottomLeft, forKey: "inputBottomLeft")

        // Apply the perspective correction
        guard let outputCIImage = perspectiveCorrectionFilter.outputImage else {
            return nil
        }

        // Create a CGAffineTransform for scaling
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)

        // Apply scaling to the output image
        let scaledCIImage = outputCIImage.transformed(by: scaleTransform)

        // Create a CIContext
        let context = CIContext(options: nil)

        // Convert the CIImage to a CGImage
        guard let outputCGImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else {
            return nil
        }

        // Create a UIImage from the CGImage and flip along the X-axis
        let croppedAndFlippedImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: .upMirrored)
//        let newImage = croppedAndFlippedImage.jjs_vMirror() ?? UIImage()
//        return newImage
        
        // 重新绘制，为了解决水平翻转问题
        let resultSize = croppedAndFlippedImage.size
        UIGraphicsBeginImageContextWithOptions(resultSize, false, image.scale)
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.translateBy(x: 0, y: resultSize.height)
        currentContext?.scaleBy(x: 1, y: -1)
        currentContext?.draw(croppedAndFlippedImage.cgImage!, in: CGRect(origin: .zero, size: resultSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func toBase64String() -> String?{
        let data = self.pngData()
        return data?.base64EncodedString()
    }
    
    class func imageFromBase64String(base64: String) -> UIImage? {
        guard let data = NSData(base64Encoded: base64),
              let image = UIImage(data: data as Data) else {
            return nil
        }
        return image
    }
    
    // 判断图片类型
    func detectImageFileType() -> String? {
        guard let data = self.pngData() else {return nil}
        let firstBytes = [UInt8](data.prefix(4))
        if firstBytes.count >= 3 {
            if firstBytes[0] == 0xFF && firstBytes[1] == 0xD8 && firstBytes[2] == 0xFF {
                return "jpg"
            } else if firstBytes[0] == 0x89 && firstBytes[1] == 0x50 && firstBytes[2] == 0x4E {
                return "png"
            } else if firstBytes[0] == 0x47 && firstBytes[1] == 0x49 && firstBytes[2] == 0x46 {
                return "gif"
            }
        }
        return nil
    }
    
}
