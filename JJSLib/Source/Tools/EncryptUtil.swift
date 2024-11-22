//
//  EncryptUtil.swift
//  App
//
//  Created by Gaorui Hou on 2023/8/8.
//

import Foundation
import CryptoSwift

public struct EncryptUtil {
    public static func aes_encrypt(_ str:String, key:String) -> String {
        var encryptedStr = ""
        do {//  AES encrypt
            let aes = try AES(key: Array(key.utf8), blockMode: ECB(), padding: .pkcs7)
            let encrypted = try aes.encrypt(str.bytes);
//            print("密文：\(encrypted.toBase64())")
            encryptedStr = encrypted.toBase64()
        } catch {
            print(error.localizedDescription)
        }
        return encryptedStr
    }


    public static func aes_decrypt(_ str:String , key:String) -> String{
        guard let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) else {
            return ""
        }
        do {
            
            var decrypted: [UInt8] = []
            decrypted = try AES(key: Array(key.utf8), blockMode: ECB(), padding: .pkcs7).decrypt(data.bytes)
            return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
    /// 读取文件内容，并转换为base64
    public static func base64FromFile(path: String) -> String?{
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return data.base64EncodedString()
    }
}
