//
//  File 2.swift
//  
//
//  Created by 김도현 on 2024/01/25.
//

import Foundation

struct GoogleAuthInfo: AuthInfo {
    
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary {
        while true {
            print("[구글] iOS Client ID를 입력해주세요")
            guard let clientID = readLine() else { continue }
            var newPlistDict = addClientID(plistDict: plistDict, iosClientID: clientID)
            print("[구글] iOS URL 스키마를 입력해주세요")
            guard let urlScheme = readLine() else { continue }
            newPlistDict = addURLTypes(plistDict: newPlistDict, reversedIosClientID: urlScheme)
            print("[구글] 서버 클라이언트 아이디가 있는 경우 입력해주세여(없을 경우 엔터)")
            guard let serverClientID = readLine() else { continue }
            guard serverClientID == "" else {
                newPlistDict = addServerClientID(plistDict: newPlistDict, serverClientID: serverClientID)
                return newPlistDict
            }
            break
        }
        return plistDict
    }
    
    private func addURLTypes(plistDict: NSMutableDictionary, reversedIosClientID: String) -> NSMutableDictionary {
        guard var urlTypes = plistDict["CFBundleURLTypes"] as? Array<[String:Any]> else {
            let newURLTypes = ["CFBundleTypeRole": "Editor", "CFBundleURLSchemes": [reversedIosClientID]] as [String : Any]
            let newPlistDict = plistDict
            newPlistDict["CFBundleURLTypes"] = [newURLTypes]
            return newPlistDict
        }
        
        let newURLType: [String: Any] = ["CFBundleTypeRole": "Editor", "CFBundleURLSchemes": [reversedIosClientID]]
        urlTypes.append(newURLType)
        plistDict["CFBundleURLTypes"] = urlTypes
        
        return plistDict
    }
    
    private func addClientID(plistDict: NSMutableDictionary, iosClientID: String) -> NSMutableDictionary {
        let newPlistDict = plistDict
        newPlistDict["GIDClientID"] = iosClientID
        return newPlistDict
    }
    
    private func addServerClientID(plistDict: NSMutableDictionary, serverClientID: String) -> NSMutableDictionary {
        let newPlistDict = plistDict
        newPlistDict["GIDServerClientID"] = serverClientID
        return newPlistDict
    }
}
