//
//  CheckPermission.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/26.
//

import Foundation
import AVFoundation
import Photos
//import EventKit
//import UserNotifications
//import Contacts

public enum LocationRequestType {
    case always
    case whenInUse
}

public enum CheckPermissionType {
    // 麦克风，需要配置 NSMicrophoneUsageDescription
    case micro
    // 相机，需要配置 NSCameraUsageDescription
    case camera
    // 相册, 配置 NSPhotoLibraryUsageDescription
    case photoLib
    // 日历, 配置 NSCalendarsUsageDescription
    case calendar
    // 推送
    case push
    // 通讯录, 配置 NSContactsUsageDescription
    case contacts
    // 定位， 配置 NSLocationWhenInUseUsageDescription、NSLocationAlwaysAndWhenInUseUsageDescription
    case location(_ type: LocationRequestType)
}

public enum CheckPermissionResult {
    case success
    case failure
}

public func jjs_checkPermission(_ type: CheckPermissionType, _ complete: @escaping ((_ result: CheckPermissionResult) -> Void)) {
    
    switch type {
    case .micro: // 麦克风权限
        AVCaptureDevice.requestAccess(for: .audio) { isGranted in
            complete((isGranted ? .success : .failure))
        }
        
    case .camera: // 相机
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            complete((isGranted ? .success : .failure))
        }
        
    case .photoLib: // 相册
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                complete(((status == .authorized || status == .limited) ? .success : .failure))
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                complete(((status == .authorized) ? .success : .failure))
            }
        }
        
    case .calendar: // 日历
//        EKEventStore().requestAccess(to: .event) { success, err in
//            complete(success ? .success : .failure)
//        }
        break;
        
    case .push: // 推送
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, err in
//            complete(success ? .success : .failure)
//        }
        break;
        
    case .contacts: // 通讯录
//        CNContactStore().requestAccess(for: .contacts) { success, err in
//            complete(success ? .success : .failure)
//        }
        break;
        
    case let .location(type) :
//        JJSLocationManager.shared.requestLocation(type) { success in
//            complete(success ? .success : .failure)
//        }
        break;
    }
    
}

/// 定位
//fileprivate class JJSLocationManager:NSObject, CLLocationManagerDelegate {
//
//    private var locationManager: CLLocationManager
//    private var complete: ((_ success: Bool) -> Void)?
//    static let shared = JJSLocationManager()
//
//    private override init() {
//        locationManager = CLLocationManager()
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func requestLocation(_ type: LocationRequestType, _ complete: @escaping ((_ success: Bool) -> Void)) {
//        self.complete = complete
//        if type == .always {
//            locationManager.requestAlwaysAuthorization()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if #available(iOS 14.0, *) {
//            complete?(( manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse ))
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        complete?(( status == .authorizedAlways || status == .authorizedWhenInUse ))
//    }
//}
