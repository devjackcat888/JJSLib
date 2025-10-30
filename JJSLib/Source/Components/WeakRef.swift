//
//  WeakRef.swift
//  Common
//
//  Created by Zhuanz密码0000 on 2025/10/30.
//

import Foundation

public final class WeakRef {
    public private(set) weak var object: AnyObject?
    public init(_ object: AnyObject) {
        self.object = object
    }
}
