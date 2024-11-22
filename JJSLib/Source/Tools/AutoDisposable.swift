//
//  AutoDisposable.swift
//  SharkAnimation
//
//  Created by SharkAnimation on 2022/12/23.
//

import RxSwift
import UIKit

public extension NSObject {
    func renewAutoDisposeBag() {
        _renewAutoDisposeBag(self)
    }
}

public extension Disposable {
    func disposing(with owner: AnyObject) {
        disposed(by: _getAutoDisposeBag(owner))
    }
}

/** private **/

private var disposeBagContext: UInt8 = 0

private func synchronizedBag<T>(_ obj: AnyObject, _ action: () -> T) -> T {
    objc_sync_enter(obj)
    let result = action()
    objc_sync_exit(obj)
    return result
}

private func _getAutoDisposeBag(_ obj: AnyObject) -> DisposeBag {
    return synchronizedBag(obj) {
        if let disposeObject = objc_getAssociatedObject(obj, &disposeBagContext) as? DisposeBag {
            return disposeObject
        }
        let disposeObject = DisposeBag()
        objc_setAssociatedObject(obj, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return disposeObject
    }
}

private func _renewAutoDisposeBag(_ obj: AnyObject) {
    synchronizedBag(obj) {
        objc_setAssociatedObject(obj, &disposeBagContext, DisposeBag(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
