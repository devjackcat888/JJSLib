//
//  SimpleError.swift
//  App
//
//  Created by Gaorui Hou on 2024/8/21.
//

import Foundation

public struct SimpleError: Error {
    public let message: String
    public init(_ message: String) {
        self.message = message
    }
    // 为了方便，可以提供一个自定义描述
    public var localizedDescription: String {
        return message
    }
}
