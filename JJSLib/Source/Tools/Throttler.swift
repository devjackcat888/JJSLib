//
//  Throttler.swift
//  GoodMood
//
//  Created by Zhuanz密码0000 on 2025/10/27.
//

import Foundation

public class Throttler {
    private var lastExecutionTime: Date = .distantPast
    private var pendingWorkItem: DispatchWorkItem?
    private let throttleInterval: TimeInterval
    private let executionQueue: DispatchQueue
    private let mode: ThrottleMode
    
    public enum ThrottleMode {
        case leading // 在时间间隔开始时执行（第一次调用立即执行）
        case trailing // 在时间间隔结束时执行（确保执行最后一次调用）
    }
    
    public init(interval: TimeInterval, queue: DispatchQueue = .main, mode: ThrottleMode = .leading) {
        self.throttleInterval = interval
        self.executionQueue = queue
        self.mode = mode
    }
    
    public func throttle(_ block: @escaping () -> Void) {
        // 取消之前挂起的任务
        pendingWorkItem?.cancel()
        
        let now = Date()
        let timeSinceLastExecution = now.timeIntervalSince(lastExecutionTime)
        
        switch mode {
        case .leading:
            if timeSinceLastExecution > throttleInterval {
                // 立即执行
                lastExecutionTime = now
                executionQueue.async {
                    block()
                }
            }
            
        case .trailing:
            let delay = timeSinceLastExecution > throttleInterval ? 0 : throttleInterval
            
            let workItem = DispatchWorkItem { [weak self] in
                self?.lastExecutionTime = Date()
                block()
            }
            
            pendingWorkItem = workItem
            
            executionQueue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    
    func cancel() {
        pendingWorkItem?.cancel()
        pendingWorkItem = nil
    }
}
