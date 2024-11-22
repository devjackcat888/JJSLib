//
//  CryptoUtil.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/25.
//

import Foundation
import CryptoSwift
import SwiftyRSA

public class CryptoUtil {
    
    public enum EncryptType {
        case AES(key: String)
        case RSA(pubKey: String)
    }
    public enum DecryptType {
        case AES(key: String)
        case RSA(priKey: String)
    }
    
    public static func encrypt(_ string: String, _ type: EncryptType) -> String?{
        do {
            switch type {
            case let .AES(key):
                    let aes = try AES(key: key.bytes, blockMode: ECB(), padding: .pkcs7)
                    let encrypted = try aes.encrypt(string.bytes)
                    return encrypted.toBase64()
                
            case let .RSA(pubKey):
                let publicKey = try PublicKey(pemEncoded: pubKey)
                let clear = try ClearMessage(string: string, using: .utf8)
                let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
                let base64String = encrypted.base64String
                return base64String
                
            }
        } catch {
            return nil
        }
    }
    public static func decrypt(_ string: String, _ type: DecryptType) -> String?{
        do {
            switch type {
            case let .AES(key):
                    let aes = try AES(key: key.bytes, blockMode: ECB(), padding: .pkcs7)
                    let decrypted = try string.decryptBase64ToString(cipher: aes)
                    return decrypted
                
            case let .RSA(priKey):
                let enData = Data(base64Encoded: string, options: .ignoreUnknownCharacters)
                if let enData {
                    let privateKey = try PrivateKey(pemEncoded: priKey)
                    let data = try EncryptedMessage(data: enData).decrypted(with: privateKey, padding: .PKCS1).data
                    return String(bytes: data.bytes, encoding: .utf8) ?? ""
                }
                return nil
            }
        } catch {
            return nil
        }
    }
}

public extension String {
    func jjs_encrypt(_ type: CryptoUtil.EncryptType) -> String? {
        return CryptoUtil.encrypt(self, type)
    }
    func jjs_decrypt(_ type: CryptoUtil.DecryptType) -> String? {
        return CryptoUtil.decrypt(self, type)
    }
    func jjs_md5() -> String {
        return self.md5()
    }
}
public extension NSString {
    func jjs_encrypt(_ type: CryptoUtil.EncryptType) -> NSString? {
        return CryptoUtil.encrypt(self as String as String, type) as NSString?
    }
    func jjs_decrypt(_ type: CryptoUtil.DecryptType) -> NSString? {
        return CryptoUtil.decrypt(self as String, type) as NSString?
    }
    func jjs_md5() -> NSString {
        return (self as String).md5() as NSString
    }
}
