//
//  EventBus.swift
//  JJSLib
//
//  Created by Zhuanz密码0000 on 2025/10/28.
//

import Foundation

public struct CallbackEvent<T: AnyObject> {
    public var vo: T
}

public typealias EventRecevieClosure<T: AnyObject> = ((CallbackEvent<T>) -> Void)
typealias SimpleEventClosure = ((_ message: AnyObject) -> Void)

protocol EventCallbackerProtocol {
    func callback(message: AnyObject)
}

private class EventCallbacker<T: AnyObject>: EventCallbackerProtocol {
    var type: AnyClass
    var handler: EventRecevieClosure<T>
    
    init(type: AnyClass, handler: @escaping EventRecevieClosure<T>) {
        self.type = type
        self.handler = handler
    }

    func callback(message: AnyObject) {
        if Swift.type(of: message) == type {
            handler(CallbackEvent(vo: message as! T))
        }
    }
}

public class EventHandlerToken {
    private var callBacker: EventCallbackerProtocol
    fileprivate init(callBacker: EventCallbackerProtocol) {
        self.callBacker = callBacker
    }
    fileprivate func callback(message: AnyObject) {
        callBacker.callback(message: message)
    }
}


class EventBusManagerHandler {
    private var managerMap = [String: NSPointerArray]()

    static let shared: EventBusManagerHandler = { EventBusManagerHandler() }()

    func addEventBus(_ eventBus: EventBus) {
        let sessionId =  eventBus.uuid
        var pointers: NSPointerArray! = managerMap[sessionId]
        if pointers == nil {
            pointers = NSPointerArray.weakObjects()
            managerMap[sessionId] = pointers
        }
        let pointer = Unmanaged.passUnretained(eventBus).toOpaque()
        pointers.addPointer(pointer)
    }

    func removeEventBus(_ eventBus: EventBus) {
        let sessionId = eventBus.uuid
        if let pointers = managerMap[sessionId] {
            if pointers.allObjects.count == 0 {
                managerMap.removeValue(forKey: sessionId)
            }
        }
    }
    
    func clearEventBuses() {
        managerMap.removeAll()
    }

    fileprivate func triggerEvent<T: AnyObject>(message: T) {
        dispatchEvent(message: message)
    }
    
    // 消息派发
    private func dispatchEvent<T: AnyObject>(message: T) {
        managerMap.values
            .forEach {
                $0.allObjects.forEach { bus in
                    (bus as! EventBus).callabckers.forEach({ token in
                        token.callback(message: message)
                    })
                }
            }
    }
}


public class EventBus {
    let uuid = UUID().uuidString
    
    fileprivate var callabckers: [EventHandlerToken] = []
    fileprivate var sendMessageClosures: [SimpleEventClosure] = []
    
    deinit {
        EventBusManagerHandler.shared.removeEventBus(self)
    }
    
    public required init() {
        EventBusManagerHandler.shared.addEventBus(self)
    }
    
    public func removeHandlerToken(_ token: EventHandlerToken) {
        callabckers.removeAll { $0 === token }
    }

    public func removeAllHandlers() {
        callabckers.removeAll()
    }
    
    public func addEventHandler<T: AnyObject>(_ type: T.Type, _ handler: @escaping EventRecevieClosure<T>){
        let callbacker = EventCallbacker(type: type, handler: handler)
        let token = EventHandlerToken(callBacker: callbacker)
        callabckers.append(token)
    }
    
    public func triggerEvent<T: AnyObject>(_ message: T) {
        EventBusManagerHandler.shared.triggerEvent(message: message)
    }
}
