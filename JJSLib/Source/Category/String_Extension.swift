//
//  String_Extension.swift
//  JJSLib
//
//  Created by Gaorui Hou on 2023/8/8.
//

import Foundation

public extension String {
//    func isBase64() -> Bool {
//        if let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions()) {
//            // Check if the decoded data can be converted back to the original string
//            if let decodedString = String(data: data, encoding: .utf8) {
//                return self == decodedString
//            }
//        }
//        return false
//    }
    
    func isJSON() -> Bool {
        if let data = self.data(using: .utf8) {
            do {
                let _ = try JSONSerialization.jsonObject(with: data, options: [])
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
