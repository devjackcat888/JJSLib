//
//  AppKeychain.swift
//  XiuPai
//
//  Created by SharkAnimation on 2023/7/3.
//

import UIKit
import KeychainAccess

public class AppKeychain {

     private var keychain: Keychain!

     public convenience init(service: String?) {
        self.init()
        if let service = service {
            self.keychain = Keychain(service:service)
        } else if let info = Bundle.main.infoDictionary, let bundleId = info["CFBundleIdentifier"] as? String {
            self.keychain = Keychain(service:bundleId)
        }
    }
    
    public func set(value:String, key:String) {
        do {
            try keychain.set(value, key: key)
        } catch let error {
            print(error)
        }
    }
    
    public func get(key: String) -> String?{
        if let value = try? keychain.getString(key) {
            return value
        }
        return nil
    }
}

