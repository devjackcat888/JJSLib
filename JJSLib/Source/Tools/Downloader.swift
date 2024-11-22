//
//  Downloader.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/25.
//

import Foundation
import RxSwift
import Alamofire

public enum JJSDownloadState {
    case process(_ process: Float)
    case success(_ filePath: String)
    case failure(_ error: Error)
}

public func jjs_download(url: String?, filename: String? = nil) -> Observable<JJSDownloadState> {
    
    return Observable<JJSDownloadState>.create { observer -> Disposable in
        
        var request: DownloadRequest?
        
        if let filename {
            // 判断是否已存在，已存在则不再处理
            let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let cacheDir = documentsURL + "/downloadCache"
            if FileManager.default.fileExists(atPath: cacheDir) == false {
                try? FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: true)
            }
            let fileURL = cacheDir + "/\(filename)"
            if FileManager.default.fileExists(atPath: fileURL) {
                observer.onNext(.success(fileURL))
                observer.onCompleted()
            } else {
                request = _download(url: url, filename: filename) { process in
                    observer.onNext(.process(process))
                } success: { path in
                    observer.onNext(.success(path))
                    observer.onCompleted()
                } failure: { error in
                    observer.onNext(.failure(error))
                }
            }
        }
        // 不存在，则还需要下载
        request = _download(url: url, filename: filename) { process in
            observer.onNext(.process(process))
        } success: { path in
            observer.onNext(.success(path))
            observer.onCompleted()
        } failure: { error in
            observer.onNext(.failure(error))
        }
        
        return Disposables.create {
            request?.cancel()
        }
    }
}

public func jjs_download(url: String?, 
                         filename: String? = nil,
                         process:((_ process: Float) -> Void)?,
                         success:@escaping ((_ filePath: String) -> Void),
                         failure:@escaping ((_ error: Error) -> Void)) {
    
    var request: DownloadRequest?
    
    if let filename {
        // 判断是否已存在，已存在则不再处理
        let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let cacheDir = documentsURL + "/downloadCache"
        if FileManager.default.fileExists(atPath: cacheDir) == false {
            try? FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: true)
        }
        let fileURL = cacheDir + "/\(filename)"
        if FileManager.default.fileExists(atPath: fileURL) {
            success(fileURL)
        } else {
            request = _download(url: url, filename: filename, process: process, success:success, failure:failure)
        }
    }
    // 不存在，则还需要下载
    request = _download(url: url, filename: filename, process: process, success:success, failure:failure)
    
}

private func _download(url: String?, filename: String?, 
                       process: ((_ process: Float) -> Void)?,
                       success:@escaping ((_ filePath: String) -> Void),
                       failure:@escaping ((_ error: Error) -> Void)) -> DownloadRequest? {
    
    let destination: DownloadRequest.Destination = { _, _ in
        let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let cacheDir = documentsURL + "/downloadCache"
        let fileURL = cacheDir + "/\(filename!)"
        return (URL(fileURLWithPath: fileURL), [.removePreviousFile, .createIntermediateDirectories])
    }
    
    // 不存在，则还需要下载
    if let url {
        return AF.download(url, to: (filename == nil ? nil : destination))
            .downloadProgress() { progress in
                // 下载进度
                process?(Float(progress.fractionCompleted))
            }
            .response { response in
                // 下载
                if let path = response.fileURL?.path, response.error == nil {
                    success(path)
                    
                } else if let error = response.error{
                    failure(error)
                    
                } else {
                    let error = NSError(domain: "下载失败", code: 1000000)
                    failure(error)
                }
            }
    } else {
        let error = NSError(domain: "url 为空", code: 1000000)
        failure(error)
        return nil
    }
}
