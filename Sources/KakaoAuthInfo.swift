//
//  File 3.swift
//  
//
//  Created by 김도현 on 2024/01/25.
//

import Foundation

struct KakaoAuthInfo: AuthInfo {
    
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary {
        while true {
            var newPlistDict = addQueriesSchemes(plistDict: plistDict)
            print("[카카오] 네이티브 앱키를 입력해주세요")
            guard let appkey = readLine() else { continue }
            createFile(apikey: ["KAKAO_APIKEY": appkey])
            newPlistDict = addURLTypes(plistDict: newPlistDict, urlScheme: appkey)
            break
        }
        return plistDict
    }
    
    private func addURLTypes(plistDict: NSMutableDictionary, urlScheme: String) -> NSMutableDictionary {
        let urlScheme = "kakao\(urlScheme)"
        guard var urlTypes = plistDict["CFBundleURLTypes"] as? Array<[String:Any]> else {
            let newURLTypes = ["CFBundleTypeRole": "Editor", "CFBundleURLSchemes": [urlScheme]] as [String : Any]
            let newPlistDict = plistDict
            newPlistDict["CFBundleURLTypes"] = [newURLTypes]
            return newPlistDict
        }
        
        let newURLType: [String: Any] = ["CFBundleTypeRole": "Editor", "CFBundleURLSchemes": [urlScheme]]
        urlTypes.append(newURLType)
        plistDict["CFBundleURLTypes"] = urlTypes
        
        return plistDict
    }
    
    private func addQueriesSchemes(plistDict: NSMutableDictionary) -> NSMutableDictionary {
        let newPlistDict = plistDict
        var queries = [String]()
        print("카카오톡으로 로그인 기능이 필요한가요?(y/n)")
        if readLine() == "y" {
            queries.append("kakaokompassauth")
        }
        print("카카오톡 공유 기능이 필요한가요?(y/n)")
        if readLine() == "y" {
            queries.append("kakaolink")
        }
        print("카카오톡 채널 기능이 필요한가요?(y/n)")
        if readLine() == "y" {
            queries.append("kakaoplus")
        }
        
        if !queries.isEmpty {
            newPlistDict["LSApplicationQueriesSchemes"] = queries
        }
        return newPlistDict
    }
}
