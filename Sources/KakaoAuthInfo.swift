//
//  File 3.swift
//  
//
//  Created by 김도현 on 2024/01/25.
//

import Foundation

struct KakaoAuthInfo: AuthInfo {
    
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary {
//        while true {
//            var newPlistDict = addQueriesSchemes(plistDict: plistDict)
//            print("iOS URL 스키마를 입력해주세요")
//            guard let urlScheme = readLine() else { continue }
//            newPlistDict = addURLTypes(plistDict: newPlistDict, urlScheme: urlScheme)
//            break
//        }
        insertKakaoInitCode()
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
    
    private func insertKakaoInitCode() {
        print("KakaoSDK를 생성하기 위한 네이티브앱 키를 입력해주세요")
        guard let nativeAppKey = readLine() else { return }
        let code = "let NATIVEAPPKEY = \(nativeAppKey)"
        
        let defaultPath = FileManager.default.currentDirectoryPath
        let projectName = URL(fileURLWithPath: defaultPath).lastPathComponent
        let apikeyFilePath = defaultPath + "/\(projectName)/APIKEY.swift"
        let appdelegateFilePath = defaultPath + "/\(projectName)/Appdelegate.swift"

        insertCodeIntoFile(filePath: appdelegateFilePath, keyword: "[UIApplication.LaunchOptionsKey: Any]?) -> Bool {", codeToInsert: "\n\t\tKakaoSDK.initSDK(appkey: NATIVEAPPKEY)", insertPosition: .back)
        
        insertCodeIntoFile(filePath: appdelegateFilePath, keyword: "UIKit", codeToInsert: "\nimport KakaoSDKCommon", insertPosition: .back)
        
        insertCodeAtLine(filePath: apikeyFilePath, lineNumber: 1, codeToInsert: code)
    }
}
