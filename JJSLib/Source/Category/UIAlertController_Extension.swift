//
//  UIAlertController_Extension.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/4/28.
//

import UIKit

public typealias JCSAlertActionHandler = () -> Void

public class JCSAlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: JCSAlertActionHandler

    init(_ title: String, style: UIAlertAction.Style , action: @escaping JCSAlertActionHandler = {}) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public class DefaultAction: JCSAlertAction {
    public init(_ title: String, action: @escaping JCSAlertActionHandler = {}) {
        super.init(title, style: .default, action: action)
    }
}

public class CancelAction: JCSAlertAction {
    public init(_ title: String, action: @escaping JCSAlertActionHandler = {}) {
        super.init(title, style: .cancel, action: action)
    }
}

public class DestructiveAction: JCSAlertAction {
    public init(_ title: String, action: @escaping JCSAlertActionHandler = {}) {
        super.init(title, style: .destructive, action: action)
    }
}

@resultBuilder public struct JCSAlertControllerBuilder {
    public static func buildBlock(_ components: JCSAlertAction...) -> [UIAlertAction] {
        components.map { action in
            UIAlertAction(title: action.title, style: action.style) { _ in
                action.action()
            }
        }
    }
}

public extension UIAlertController {
    
//        let alert = UIAlertController(title: "Delete all data?", message: "All your data will be deleted!") {
//            DestructiveAction("Yes ,Delete is All") {
//                print("Deleting all data")
//            }
//            DefaultAction("Show More Options") {
//                print("Show more options")
//            }
//            CancelAction("No, Don‘t Delete Anything")
//        }
//        present(alert, animated: true)
    
//    convenience init(title: String,
//                     message: String,
//                     style: UIAlertController.Style = .alert,
//                     @JCSAlertControllerBuilder build: () -> [UIAlertAction]) {
//        let actions = build()
//        self.init(title: title, message: message, preferredStyle: style)
//        actions.forEach{
//            self.addAction($0)
//        }
//    }
    
    convenience init(title: String = "",
                     message: String = "",
                     style: UIAlertController.Style = .alert,
                     cancelTitle: String? = "取消",
                     confirmTitle: String = "确定",
                     cancelAction: (() -> Void)? = nil,
                     confirmAction: ((_ sender: UIAlertController) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: style)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = self.popoverPresentationController {
                guard let topView = UIApplication.topViewController()?.view else {
                    return
                }
                popoverController.sourceView = topView
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        if let cancelTitle {
            let _cancelAction =  UIAlertAction(title: cancelTitle , style: .cancel) { action in
                cancelAction?()
            }
            addAction(_cancelAction)
        }
        
        let _openAction = UIAlertAction(title:  confirmTitle, style: .default) { [weak self] action in
            if let self {
                confirmAction?(self)
            }
        }
        addAction(_openAction)
    }
    
    func show() {
        UIApplication.topViewController()?.present(self, animated: true)
    }
}
