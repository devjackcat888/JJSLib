//
//  AppDelegate.swift
//  Example
//
//  Created by SharkAnimation on 2023/5/14.
//

import UIKit
import JJSLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let eventBus3 = EventBus()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        eventBus3.addEventHandler(Person.self) { event in
            print("--- person id 3 = \(event.vo.id)")
        }
        eventBus3.addEventHandler(User.self) { event in
            print("--- User id 3 = \(event.vo.id)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

