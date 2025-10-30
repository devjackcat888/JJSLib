//
//  UIView_JJSCreate.swift
//  AniApp
//
//  Created by JJS on 2023/5/4.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

private struct AssociatedKeys {
    static var customerDelegateKey: UInt8 = 0
    static var topNameKey: UInt8 = 0
    static var rightNameKey: UInt8 = 0
    static var bottomNameKey: UInt8 = 0
    static var leftNameKey: UInt8 = 0
    static var UIControlClickDisposableKey: UInt8 = 0
    static var TextFieldMaxLengthDisposableKey: UInt8 = 0
    static var TextFieldMaxLengthWeakSelfKey: UInt8 = 0
    
}

// 定义协议
public protocol JJS_ColorRepresentable {}
public protocol JJS_FontRepresentable {}

public enum JJS_Color {
    case color(_ color: UIColor)
    case hex(_ hex: String, _ alpha: CGFloat = 1)
}

public enum JJS_Font{
    case font(_ font: UIFont)
    case size(_ size: CGFloat)
}

fileprivate func genColor(color: JJS_Color) -> UIColor? {
    var _color: UIColor?
    switch color {
    case let .color(color):
        _color = color
    case let .hex(hex, alpha):
        _color = UIColor(hex, alpha: alpha)
    }
    return _color
}

fileprivate func genFont(font: JJS_Font) -> UIFont? {
    var _font: UIFont?
    switch font {
    case let .font(font):
        _font = font
    case let .size(size):
        _font = .systemFont(ofSize: size)
    }
    return _font
}

public extension UIView {
    
    @discardableResult
    func jjs_layout(superView: UIView, _ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        if let stackView = superView as? UIStackView {
            stackView.addArrangedSubview(self)
        } else {
            superView.addSubview(self)
        }
        
        self.snp.makeConstraints(closure)
        return self
    }
    @discardableResult
    func jjs_layout(superView: UIView, _ frame: CGRect) -> Self {
        superView.addSubview(self)
        self.frame = frame
        return self
    }
    @discardableResult
    func jjs_layout(superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    @discardableResult
    func jjs_setFrame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    @discardableResult
    func jjs_setBounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    
    @discardableResult
    func jjs_setBackgroundColor(_ hexColor: String) -> Self {
        backgroundColor = UIColor(hexColor)
        return self
    }
    @discardableResult
    func jjs_setBackgroundColor(_ hexColor: UIColor?) -> Self {
        backgroundColor = hexColor
        return self
    }
    @discardableResult
    func jjs_setBackgroundColor(_ color: JJS_Color?) -> Self {
        if let color {
            backgroundColor = genColor(color: color)
        } else {
            backgroundColor = nil
        }
        return self
    }
    @discardableResult
    func jjs_clearBackgroundColor() -> Self {
        backgroundColor = .clear
        return self
    }
    
    @discardableResult
    func jjs_setAlpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func jjs_setHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
    
    @discardableResult
    func jjs_setUserInteractionEnabled(_ enabled: Bool) -> Self {
        self.isUserInteractionEnabled = enabled
        return self
    }
    
    @discardableResult
    func jjs_bringToFront() -> Self {
        self.superview?.bringSubviewToFront(self)
        return self
    }
    
    @discardableResult
    func jjs_sendToBack() -> Self {
        self.superview?.sendSubviewToBack(self)
        return self
    }
    
    
    @discardableResult
    func jjs_setCornerRadius(_ cornerRadius: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
        return self
    }
    @discardableResult
    func jjs_setClipsToBounds(_ clipsToBounds: Bool = true) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
    @discardableResult
    func jjs_setMaskedCorners(_ corners: CACornerMask = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]) -> Self {
        layer.maskedCorners = corners
        return self
    }

    @discardableResult
    func jjs_setContentMode(_ contentMode: ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult
    func jjs_setBorderColor(_ color: String, alpha: CGFloat = 1) -> Self {
        self.layer.borderColor = UIColor(color,alpha: alpha).cgColor
        return self
    }
    @discardableResult
    func jjs_setBorderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }
    @discardableResult
    func jjs_setBorderWidth(_ width: CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }
 
}

public extension UIButton {
    
    enum JJSImagePosition {
        case left, right, top, bottom
    }
    
    @discardableResult
    func jjs_setTitle(_ title: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func jjs_setTitleColor(_ color: String, alpha: CGFloat = 1, state: UIControl.State = .normal) -> Self {
        setTitleColor(UIColor(color,alpha: alpha), for: state)
        return self
    }
    @discardableResult
    func jjs_setTitleColor(_ color: UIColor?, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    @discardableResult
    func jjs_setTitleColor(_ color: JJS_Color?, _ state: UIControl.State = .normal) -> Self {
        if let color {
            setTitleColor(genColor(color: color), for: state)
        } else {
            setTitleColor(nil, for: state)
        }
        return self
    }
    
    @discardableResult
    func jjs_setImage(_ imageName: String, _ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        var image = UIImage(named: imageName)
        if let renderColor {
            if #available(iOS 13.0, *) {
                image = image?.withTintColor(renderColor, renderingMode: .alwaysOriginal)
            } else {
            }
        }
        setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func jjs_setImage(_ image: UIImage?, _ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        var _image = image
        if let image, let renderColor {
            _image = image.withTintColor(renderColor, renderingMode: .alwaysOriginal)
        }
        setImage(_image, for: state)
        return self
    }
    @discardableResult
    func jjs_setImageNil(_ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        setImage(nil, for: state)
        return self
    }
    
    @discardableResult
    func jjs_setFont(_ font: JJS_Font?) -> Self {
        if let font {
            titleLabel?.font = genFont(font: font)
        } else {
            titleLabel?.font = nil
        }
        return self
    }
    @discardableResult
    func jjs_setFont(_ font: UIFont?) -> Self {
        titleLabel?.font = font
        return self
    }
    @discardableResult
    func jjs_setFontSize(_ size: CGFloat) -> Self {
        titleLabel?.font = .systemFont(ofSize: size)
        return self
    }
    @discardableResult
    func jjs_setTitleAlignment(_ value: NSTextAlignment) -> Self {
        titleLabel?.textAlignment = value
        return self
    }
    
    @discardableResult
    func jjs_setBackgroundImage(_ imageName: String, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(UIImage(named: imageName), for: state)
        return self
    }
    @discardableResult
    func jjs_setBackgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    @discardableResult
    func jjs_setAdjustsImageWhenDisabled(_ adjusts: Bool) -> Self {
        adjustsImageWhenDisabled = adjusts
        return self
    }
    @discardableResult
    func jjs_setAdjustsImageWhenHighlighted(_ adjusts: Bool) -> Self {
        adjustsImageWhenHighlighted = adjusts
        return self
    }
    
    @discardableResult
    func jjs_setContentEdgeInsets(_ value: UIEdgeInsets) -> Self {
        contentEdgeInsets = value
        return self
    }
    
    
    @discardableResult
    func jjs_setImagePosition(_ position: JJSImagePosition, spacing: CGFloat) -> Self {
        guard let imageSize = imageView?.image?.size,
            let text = titleLabel?.text,
            let font = titleLabel?.font else {
            return self
        }

        let titleSize = text.size(withAttributes: [.font: font])

        let imageOffsetX = (imageSize.width + titleSize.width) / 2 - imageSize.width / 2// image中心移动的x距离
        let imageOffsetY = imageSize.height / 2 + spacing / 2// image中心移动的y距离
        let labelOffsetX = (imageSize.width + titleSize.width / 2) - (imageSize.width + titleSize.width) / 2// label中心移动的x距离
        let labelOffsetY = titleSize.height / 2 + spacing / 2// label中心移动的y距离

        let tempWidth = max(titleSize.width, imageSize.width)
        let changedWidth = titleSize.width + imageSize.width - tempWidth
        let tempHeight = max(titleSize.height, imageSize.height)
        let changedHeight = titleSize.height + imageSize.height + spacing - tempHeight

        switch position {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -0.5 * changedWidth, bottom: changedHeight-imageOffsetY, right: -0.5 * changedWidth)

        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -0.5 * changedWidth, bottom: imageOffsetY, right: -0.5 * changedWidth)

        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + 0.5 * spacing, bottom: 0, right: -(titleSize.width + 0.5 * spacing))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + 0.5 * spacing), bottom: 0, right: imageSize.width + spacing * 0.5)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: 0.5*spacing)

        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * spacing, bottom: 0, right: 0.5 * spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: -0.5 * spacing)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: 0.5 * spacing)
        }
        return self
    }
    
    @discardableResult
    func jjs_enlargeEdge(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) -> Self {
        objc_setAssociatedObject(self, &AssociatedKeys.topNameKey, NSNumber(value: Float(top)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.rightNameKey, NSNumber(value: Float(right)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.bottomNameKey, NSNumber(value: Float(bottom)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.leftNameKey, NSNumber(value: Float(left)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }
    private func enlargedRect() -> CGRect {
        let topEdge = objc_getAssociatedObject(self, &AssociatedKeys.topNameKey) as? NSNumber
        let rightEdge = objc_getAssociatedObject(self, &AssociatedKeys.rightNameKey) as? NSNumber
        let bottomEdge = objc_getAssociatedObject(self, &AssociatedKeys.bottomNameKey) as? NSNumber
        let leftEdge = objc_getAssociatedObject(self, &AssociatedKeys.leftNameKey) as? NSNumber
        
        if let topEdge = topEdge, let rightEdge = rightEdge, let bottomEdge = bottomEdge, let leftEdge = leftEdge {
            return CGRect(x: bounds.origin.x - CGFloat(leftEdge.floatValue),
                          y: bounds.origin.y - CGFloat(topEdge.floatValue),
                          width: bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue),
                          height: bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
        } else {
            return bounds
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if alpha <= 0.1 || isHidden {
            return nil
        }
        
        let rect = enlargedRect()
        if rect.equalTo(bounds) {
            return super.hitTest(point, with: event)
        }
        
        return rect.contains(point) ? self : nil
    }
}

public extension UIControl {

    private func getClickDisposable() -> Disposable?{
        return objc_getAssociatedObject(self, &AssociatedKeys.UIControlClickDisposableKey) as? Disposable
    }
    private func updateClickDisposable(_ bag: Disposable?){
        objc_setAssociatedObject(self, &AssociatedKeys.UIControlClickDisposableKey, bag, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @discardableResult
    func jjs_clickBlock(_ handler: @escaping () -> Void) -> Self{
        // 释放资源
        getClickDisposable()?.dispose()
        updateClickDisposable(nil)
        // 重新添加资源
        let bag = self.rx.controlEvent(.touchUpInside)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { sender in
                handler()
            })
        updateClickDisposable(bag)
        return self
    }

    @discardableResult
    func jjs_setIsSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
    @discardableResult
    func jjs_setIsHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }
    @discardableResult
    func jjs_setIsEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
}

public extension UITextField {
    
    @discardableResult
    func jjs_setText(_ text: String?) -> Self{
        self.text = text
        return self
    }
    
    @discardableResult
    func jjs_setFont(_ font: JJS_Font?) -> Self {
        if let font {
            self.font = genFont(font: font)
        } else {
            self.font = nil
        }
        return self
    }
    @discardableResult
    func jjs_setFont(_ font: UIFont) -> Self{
        self.font = font
        return self
    }
    @discardableResult
    func jjs_setFontSize(_ fontSize: CGFloat) -> Self{
        self.font = .systemFont(ofSize: fontSize)
        return self
    }
    @discardableResult
    func jjs_setMinimumFontSize(_ fontSize: CGFloat) -> Self{
        self.minimumFontSize = fontSize
        return self
    }
    

    @discardableResult
    func jjs_setTextColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.textColor = UIColor(color,alpha: alpha)
        return self
    }
    @discardableResult
    func jjs_setTextColor(_ color: UIColor?) -> Self{
        self.textColor = color
        return self
    }
    @discardableResult
    func jjs_setTextColor(_ color: JJS_Color?, _ state: UIControl.State = .normal) -> Self {
        if let color {
            self.textColor = genColor(color: color)
        } else {
            self.textColor = nil
        }
        return self
    }
    
    @discardableResult
    func jjs_setTextAlignment(_ align: NSTextAlignment) -> Self{
        self.textAlignment = align
        return self
    }
    
    @discardableResult
    func jjs_setReturnKeyType(_ value: UIReturnKeyType) -> Self{
        self.returnKeyType = value
        return self
    }
    @discardableResult
    func jjs_setPlaceholder(_ value: String) -> Self{
        self.placeholder = value
        return self
    }
    @discardableResult
    func jjs_setBorderStyle(_ value: UITextField.BorderStyle) -> Self{
        self.borderStyle = value
        return self
    }
    
    @discardableResult
    func jjs_setAttributedPlaceholder(_ text: String, color: JJS_Color? = nil, font: JJS_Font? = nil) -> Self{
        var attributes = [NSAttributedString.Key:Any]()
        if let font, let _font = genFont(font: font) {
            attributes[.font] = _font
        }
        if let color, let _color = genColor(color: color) {
            attributes[.foregroundColor] = _color
        }
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        return self
    }
    @discardableResult
    func jjs_setAttributedPlaceholder(_ text: String, attributes: [NSAttributedString.Key:Any]?) -> Self{
        let att = NSAttributedString(string: text, attributes: attributes)
        self.attributedPlaceholder = att
        return self
    }
    
    @discardableResult
    func jjs_setAttributedText(_ value: NSAttributedString) -> Self{
        self.attributedText = value
        return self
    }
    @discardableResult
    func jjs_setAttributedText(_ text: String, attributes: [NSAttributedString.Key:Any]?) -> Self{
        let att = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = att
        return self
    }
    @discardableResult
    func jjs_setAttributedText(_ text: String, color: JJS_Color? = nil, font: JJS_Font? = nil) -> Self{
        var attributes = [NSAttributedString.Key:Any]()
        if let font, let _font = genFont(font: font) {
            attributes[.font] = _font
        }
        if let color, let _color = genColor(color: color) {
            attributes[.foregroundColor] = _color
        }
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
        return self
    }
    
    @discardableResult
    func jjs_setKeyboardType(_ value: UIKeyboardType) -> Self{
        self.keyboardType = value
        return self
    }
    
    @discardableResult
    func jjs_setClearsOnBeginEditing(_ value: Bool) -> Self{
        self.clearsOnBeginEditing = value
        return self
    }
    
    @discardableResult
    func jjs_setAdjustsFontSizeToFitWidth(_ value: Bool) -> Self{
        self.adjustsFontSizeToFitWidth = value
        return self
    }
    
    @discardableResult
    func jjs_setDisabledBackground(_ value: UIImage?) -> Self{
        self.disabledBackground = value
        return self
    }
    @discardableResult
    func jjs_setBackground(_ value: UIImage?) -> Self{
        self.background = value
        return self
    }
    
    @discardableResult
    func jjs_setClearButtonMode(_ value: UITextField.ViewMode) -> Self{
        self.clearButtonMode = value
        return self
    }
    
    @discardableResult
    func jjs_setDelegate(_ value: (any UITextFieldDelegate)?) -> Self{
        self.delegate = value
        return self
    }
    
    @discardableResult
    func jjs_setLeftView(_ value: UIView?) -> Self{
        self.leftView = value
        return self
    }
    @discardableResult
    func jjs_setRightView(_ value: UIView?) -> Self{
        self.rightView = value
        return self
    }
    
    @discardableResult
    func jjs_setLeftViewMode(_ value: UITextField.ViewMode) -> Self{
        self.leftViewMode = value
        return self
    }
    @discardableResult
    func jjs_setRightViewMode(_ value: UITextField.ViewMode) -> Self{
        self.rightViewMode = value
        return self
    }
    
    @discardableResult
    func jjs_editingDidEndClosure(_ closure: @escaping () -> Void) -> Self{
        self.rx.controlEvent(.editingDidEnd)
                    .subscribe(onNext: {
                        closure()
                    })
                    .disposing(with: self)
        return self
    }
    
    private func getMaxLengthDisposable() -> Disposable?{
        return objc_getAssociatedObject(self, &AssociatedKeys.TextFieldMaxLengthDisposableKey) as? Disposable
    }
    private func updateMaxLengthDisposable(_ bag: Disposable?){
        objc_setAssociatedObject(self, &AssociatedKeys.TextFieldMaxLengthDisposableKey, bag, .OBJC_ASSOCIATION_RETAIN)
    }
    private func updateWeakSelfDisposable(_ obj: AnyObject?){
        objc_setAssociatedObject(self, &AssociatedKeys.TextFieldMaxLengthWeakSelfKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @discardableResult
    func jjs_setMaxLength(_ maxLength: Int) -> Self{
        updateWeakSelfDisposable(nil)
        let weakRef = WeakRef(self)
        updateWeakSelfDisposable(weakRef)
        // 释放资源
        getMaxLengthDisposable()?.dispose()
        updateMaxLengthDisposable(nil)
//         重新添加资源
        let bag = self.rx.text
            .observe(on: MainScheduler.asyncInstance) // 确保在主线程
            .subscribe(onNext: {  text in
                guard let currentText = text, currentText.count > maxLength else { return }
                let index = currentText.index(currentText.startIndex, offsetBy: maxLength)
                (weakRef.object as? UITextField)?.text = String(currentText[..<index])
            })
        updateMaxLengthDisposable(bag)
        return self
    }
}

public extension UILabel {
    
    convenience init(text: String?, font: CGFloat, textColor: UIColor?, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.jjs_setText(text).jjs_setFontSize(font).jjs_setTextColor(textColor).jjs_setTextAlignment(align)
    }
    convenience init(text: String?, font: UIFont, textColor: UIColor?, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.jjs_setText(text).jjs_setFont(font).jjs_setTextColor(textColor).jjs_setTextAlignment(align)
    }
    convenience init(text: String?, font: CGFloat, textColor: String, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.jjs_setText(text).jjs_setFontSize(font).jjs_setTextColor(textColor).jjs_setTextAlignment(align)
    }
    convenience init(text: String?, font: UIFont, textColor: String, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.jjs_setText(text).jjs_setFont(font).jjs_setTextColor(textColor).jjs_setTextAlignment(align)
    }
    
    @discardableResult
    func jjs_setText(_ text: String?) -> Self{
        self.text = text
        return self
    }
    
    @discardableResult
    func jjs_setFont(_ font: JJS_Font?) -> Self {
        if let font {
            self.font = genFont(font: font)
        } else {
            self.font = nil
        }
        return self
    }
    @discardableResult
    func jjs_setFont(_ font: UIFont) -> Self{
        self.font = font
        return self
    }
    @discardableResult
    func jjs_setFontSize(_ fontSize: CGFloat) -> Self{
        self.font = .systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func jjs_setTextColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.textColor = UIColor(color,alpha: alpha)
        return self
    }
    @discardableResult
    func jjs_setTextColor(_ color: UIColor?) -> Self{
        self.textColor = color
        return self
    }
    @discardableResult
    func jjs_setTextColor(_ color: JJS_Color?, _ state: UIControl.State = .normal) -> Self {
        if let color {
            self.textColor = genColor(color: color)
        } else {
            self.textColor = nil
        }
        return self
    }
    
    @discardableResult
    func jjs_setTextAlignment(_ align: NSTextAlignment) -> Self{
        self.textAlignment = align
        return self
    }
    
    @discardableResult
    func jjs_setNumberOfLines(_ lines: Int) -> Self{
        self.numberOfLines = lines
        return self
    }
}

public extension UIImageView {
    @discardableResult
    func jjs_setImage(_ image: Any?) -> Self{
        guard let image else {
            return self
        }
        if let image = image as? String {
            if image.hasPrefix("http://") || image.hasPrefix("https://") {
                self.kf.indicatorType = .activity
                let temp = image//.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                self.sd_setImage(with: URL(string: temp!))
                self.kf.setImage(with: URL(string: temp),
                options: [
                    .transition(.fade(0.4)) // 过渡动画
                ])
//                let processor = DownsamplingImageProcessor(size: self.bounds.size)
//                             |> RoundCornerImageProcessor(cornerRadius: 20)
//                self.kf.setImage(with: URL(string: image),options: [
//                    .processor(processor),
//                    .scaleFactor(UIScreen.main.scale),
//                    .transition(.fade(1)),
//                    .cacheOriginalImage
//                ])
            } else {
                self.kf.cancelDownloadTask()
//                self.sd_cancelCurrentImageLoad()
                self.image = UIImage(named: image)
            }
        } else if let image = image as? UIImage {
            self.image = image
        }
        return self
    }
    
    @discardableResult
    func jjs_setImageNil() -> Self {
        self.image = nil
        return self
    }
}

public extension UISlider {

    @discardableResult
    func jjs_setValue(_ value: Float) -> Self{
        self.value = value
        return self
    }
    
    @discardableResult
    func jjs_setMinimumValue(_ value: Float) -> Self{
        self.minimumValue = value
        return self
    }
    @discardableResult
    func jjs_setMaximumValue(_ value: Float) -> Self{
        self.maximumValue = value
        return self
    }
    
    @discardableResult
    func jjs_setMinimumValueImage(_ image: UIImage?) -> Self{
        self.minimumValueImage = image
        return self
    }
    @discardableResult
    func jjs_setMinimumValueImage(_ image: String) -> Self{
        self.minimumValueImage = UIImage(named: image)
        return self
    }
    
    @discardableResult
    func jjs_setMaximumValueImage(_ image: UIImage?) -> Self{
        self.maximumValueImage = image
        return self
    }
    @discardableResult
    func jjs_setMaximumValueImage(_ image: String) -> Self{
        self.maximumValueImage = UIImage(named: image)
        return self
    }
    
    @discardableResult
    func jjs_setIsContinuous(_ isContinuous: Bool) -> Self{
        self.isContinuous = isContinuous
        return self
    }
    
    @discardableResult
    func jjs_setMinimumTrackTintColor(_ color: UIColor?) -> Self{
        self.minimumTrackTintColor = color
        return self
    }
    @discardableResult
    func jjs_setMinimumTrackTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.minimumTrackTintColor = UIColor(color, alpha: alpha)
        return self
    }
    
    @discardableResult
    func jjs_setMaximumTrackTintColor(_ color: UIColor?) -> Self{
        self.maximumTrackTintColor = color
        return self
    }
    @discardableResult
    func jjs_setMaximumTrackTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.maximumTrackTintColor = UIColor(color, alpha: alpha)
        return self
    }
    
    @discardableResult
    func jjs_setThumbTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.thumbTintColor = UIColor(color, alpha: alpha)
        return self
    }
    @discardableResult
    func jjs_setThumbTintColor(_ color: UIColor) -> Self{
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func jjs_setThumbImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setThumbImage(image, for: state)
        return self
    }
    @discardableResult
    func jjs_setThumbImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setThumbImage(UIImage(named: image), for: state)
        return self
    }
    
    @discardableResult
    func jjs_setMinimumTrackImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setMinimumTrackImage(image, for: state)
        return self
    }
    @discardableResult
    func jjs_setMinimumTrackImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setMinimumTrackImage(UIImage(named: image), for: state)
        return self
    }
    @discardableResult
    func jjs_setMaximumTrackImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setMaximumTrackImage(image, for: state)
        return self
    }
    @discardableResult
    func jjs_setMaximumTrackImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setMaximumTrackImage(UIImage(named: image), for: state)
        return self
    }
    
    @discardableResult
    func jjs_setTarget(_ changed: @escaping ((_ value: CGFloat) -> Void),
                       changeBegin: ((_ value: CGFloat) -> Void)? = nil,
                       changeEnd: ((_ value: CGFloat) -> Void)? = nil) -> Self {
        
        let target = JJSSliderTarget { value in
            changed(CGFloat(value))
        } changeBegin: { value in
            changeBegin?(CGFloat(value))
        } changeEnd: { value in
            changeEnd?(CGFloat(value))
        }

        addTarget(target, action: #selector(JJSSliderTarget.valueChanged(_:)), for: .valueChanged)
        addTarget(target, action: #selector(JJSSliderTarget.changeBegin(_:)), for: .editingDidBegin)
        addTarget(target, action: #selector(JJSSliderTarget.changeEnd(_:)), for: .editingDidEnd)
    
        objc_setAssociatedObject(self, &AssociatedKeys.customerDelegateKey, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return self
    }
}

public extension UICollectionViewFlowLayout {
    
    @discardableResult
    func jjs_setItemSize(_ size: CGSize) -> Self{
        self.itemSize = size
        return self
    }
    
    @discardableResult
    func jjs_setMinimumLineSpacing(_ spacing: CGFloat) -> Self{
        self.minimumLineSpacing = spacing
        return self
    }
    @discardableResult
    func jjs_setMinimumInteritemSpacing(_ spacing: CGFloat) -> Self{
        self.minimumInteritemSpacing = spacing
        return self
    }
    
    @discardableResult
    func jjs_setScrollDirection(_ direction: UICollectionView.ScrollDirection) -> Self{
        self.scrollDirection = direction
        return self
    }
    
}

public extension UIScrollView {
    
    @discardableResult
    func jjs_setContentInset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    @discardableResult
    func jjs_setContentSize(_ contentSize: CGSize) -> Self {
        self.contentSize = contentSize
        return self
    }
    @discardableResult
    func jjs_setContentOffset(_ contentOffset: CGPoint) -> Self {
        self.contentOffset = contentOffset
        return self
    }
    
    @discardableResult
    func jjs_setBounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    
    @discardableResult
    func jjs_setScrollEnabled(_ enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }
    
    @discardableResult
    func jjs_setShowsVerticalScrollIndicator(_ show: Bool) -> Self {
        self.showsVerticalScrollIndicator = show
        return self
    }
    @discardableResult
    func jjs_setShowsHorizontalScrollIndicator(_ show: Bool) -> Self {
        self.showsHorizontalScrollIndicator = show
        return self
    }
    @discardableResult
    func jjs_hiddenBothScrollIndicator() -> Self {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        return self
    }
    
    @discardableResult
    func jjs_setPagingEnabled(_ enabled: Bool) -> Self {
        self.isPagingEnabled = enabled
        return self
    }
    
    @discardableResult
    func jjs_setDelegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public extension UICollectionView {
    
//    private func updateCustomerDelegate<T>(_ delegate: JJSCollectionViewDelegate<T>?) {
//        objc_setAssociatedObject(self, &customerDelegateKey, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//    }
//    private func getCustomerDelegate<T>() -> JJSCollectionViewDelegate<T>? {
//        return objc_getAssociatedObject(self, &customerDelegateKey) as? JJSCollectionViewDelegate
//    }
     
    convenience init(frame: CGRect, flowLayoutMaker:((_ layout: UICollectionViewFlowLayout) -> Void)) {
        let layout = UICollectionViewFlowLayout()
        flowLayoutMaker(layout)
        self.init(frame: frame, collectionViewLayout: layout)
    }
    
    @discardableResult
    func jjs_setDelegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func jjs_setDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) -> Self {
        self.delegate = delegate
        self.dataSource = delegate
        return self
    }
    @discardableResult
    func jjs_setDataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    @discardableResult
    func jjs_register(_ cellClass: AnyClass?, identifier: String) -> Self {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    @discardableResult
    func jjs_register(_ viewClass: AnyClass?, supplementaryViewOfKind: String, identifier: String) -> Self {
        self.register(viewClass, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: identifier)
        return self
    }
    
//    @discardableResult
//    func jjs_customerDelegate<T:JJSListItemProtocol>(dataSource: @escaping (() -> [T]), dataForCell: @escaping ((_ data: T, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void), didSelected: ((_ indexPath: IndexPath, _ data: T) -> Void)? = nil, scrollViewDelegate: (UIScrollViewDelegate)? = nil) -> Self {
//
//        let delegate = JJSCollectionViewDelegate(datasourceClosure: dataSource, dataForCellClosure: dataForCell, didSelectedClosure: didSelected, scrollViewDelegate: scrollViewDelegate)
//
////        let delegate = JJSCollectionViewDelegate(datasourceClosure: dataSource) { data, cell, indexPath in
////            dataForCell(data, cell, indexPath)
////
////        } didSelectedClosure: { indexPath, data in
////            if let didSelected {
////                didSelected(indexPath, data)
////            }
////        }
//        updateCustomerDelegate(delegate)
//        self.jjs_setDelegate(delegate)
//        return self
//    }
}

public extension UITableView {
    
    // 注册
    
    @discardableResult
    func jjs_registerCellClass(_ cellClass: AnyClass, identifier: String) -> Self{
        self.register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    @discardableResult
    func jjs_registerSectionHeaderFooterClass(_ aClass: AnyClass, identifier: String) -> Self{
        self.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    // 代理
    @discardableResult
    func jjs_setDelegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func jjs_setDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) -> Self {
        self.delegate = delegate
        self.dataSource = delegate
        return self
    }
    @discardableResult
    func jjs_setDataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
//    #pragma mark - 行高
    @discardableResult
    func jjs_setRowHeight(_ value: CGFloat) -> Self {
        self.rowHeight = value
        return self
    }
    @discardableResult
    func jjs_setEstimatedRowHeight(_ value: CGFloat) -> Self {
        self.estimatedRowHeight = value
        return self
    }
    
//    #pragma mark - 区高
    @discardableResult
    func jjs_setEstimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = value
        return self
    }
    @discardableResult
    func jjs_setEstimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = value
        return self
    }
    @discardableResult
    func jjs_setSectionHeaderHeight(_ value: CGFloat) -> Self {
        self.sectionHeaderHeight = value
        return self
    }
    @discardableResult
    func jjs_setSectionFooterHeight(_ value: CGFloat) -> Self {
        self.sectionFooterHeight = value
        return self
    }

//    #pragma mark - 分隔栏
    @discardableResult
    func jjs_setSeparatorColor(_ color: String) -> Self {
        self.separatorColor = UIColor(color)
        return self
    }
    @discardableResult
    func jjs_setSeparatorColor(_ color: UIColor?) -> Self {
        self.separatorColor = color
        return self
    }
    @discardableResult
    func jjs_setSeparatorColor(_ color: JJS_Color?, _ state: UIControl.State = .normal) -> Self {
        if let color {
            self.separatorColor = genColor(color: color)
        } else {
            self.separatorColor = nil
        }
        return self
    }
    @discardableResult
    func jjs_setSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    @discardableResult
    func jjs_setSeparatorStyleNone() -> Self {
        self.separatorStyle = .none
        return self
    }
    @discardableResult
    func jjs_setSeparatorInset(_ insets: UIEdgeInsets) -> Self {
        self.separatorInset = insets
        return self
    }

//    #pragma mark - 选择
    @discardableResult
    func jjs_setAllowsSelection(_ value: Bool) -> Self {
        self.allowsSelection = value
        return self
    }
    @discardableResult
    func jjs_setAllowsMultipleSelection(_ value: Bool) -> Self {
        self.allowsMultipleSelection = value
        return self
    }
    
//    #pragma mark - 表头、表尾
    @discardableResult
    func jjs_setTableHeaderView(_ view: UIView?) -> Self {
        self.tableHeaderView = view
        return self
    }
    @discardableResult
    func jjs_setTableFooterView(_ view: UIView?) -> Self {
        self.tableFooterView = view
        return self
    }
    @discardableResult
    func jjs_setTableHeaderNone() -> Self {
        self.tableHeaderView = nil
        return self
    }
    @discardableResult
    func jjs_setTableFooterViewNone() -> Self {
        self.tableFooterView = nil
        return self
    }
    
    @discardableResult
    func jjs_setEditing(_ value: Bool) -> Self {
        self.isEditing = value
        return self
    }

}

public extension UITableViewCell {
    @discardableResult
    func jjs_setSelectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
    @discardableResult
    func jjs_setSelectionStyleNone() -> Self {
        self.selectionStyle = .none
        return self
    }
}


extension UIEdgeInsets {
    func jjs_negate() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

extension CGPoint {
    func jjs_negate() -> CGPoint {
        return CGPoint(x: -x, y: -y)
    }
}

public class JJSSliderTarget {
    
    let changing: (Float) -> Void
    let changeBegin: (Float) -> Void
    let changeEnd: (Float) -> Void

    init(changing: @escaping (Float) -> Void, changeBegin: @escaping (Float) -> Void, changeEnd: @escaping (Float) -> Void) {
        self.changing = changing
        self.changeBegin = changeBegin
        self.changeEnd = changeEnd
    }

    @objc func valueChanged(_ sender: UISlider) {
        changing(sender.value)
    }
    @objc func changeBegin(_ sender: UISlider) {
        changeBegin(sender.value)
    }
    @objc func changeEnd(_ sender: UISlider) {
        changeEnd(sender.value)
    }
}
