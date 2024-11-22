//
//  DelayClosure.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/24.
//

import Foundation

@discardableResult
public func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DispatchWorkItem {
    let workItem = DispatchWorkItem(block: task)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: workItem)
    return workItem
}

