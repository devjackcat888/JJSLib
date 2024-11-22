//
//  String+Extension.swift
//  App
//
//  Created by Gaorui Hou on 2023/12/2.
//

import Foundation

public extension String {
    func containsChineseOrDigitOrLetter() -> Bool {
        // 定义一个包含中文汉字、数字、英文字母的正则表达式
        let pattern = "[\\u4e00-\\u9fa50-9a-zA-Z]"
        
        // 创建正则表达式对象
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            // 在字符串中查找匹配项
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            // 如果找到至少一个匹配项，返回true
            return !matches.isEmpty
        }
        
        // 如果正则表达式创建失败，返回false
        return false
    }
    
    func containsChinese() -> Bool {
        // 定义一个包含中文汉字、数字、英文字母的正则表达式
        let pattern = "[\\u4e00-\\u9fa5]"
        
        // 创建正则表达式对象
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            // 在字符串中查找匹配项
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            // 如果找到至少一个匹配项，返回true
            return !matches.isEmpty
        }
        
        // 如果正则表达式创建失败，返回false
        return false
    }
}
