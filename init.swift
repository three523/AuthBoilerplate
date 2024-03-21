//
//  main.swift
//  Setup
//
//  Created by 김도현 on 2024/01/29.
//

import Foundation

@main
class myApp {
    static let baseProjectName = "BaseProject"
    static let baseDomain = "com.KD.BaseProject"
    static var projectName = URL(fileURLWithPath: defaultPath).lastPathComponent
    static var defaultPath = FileManager.default.currentDirectoryPath
    static var bundleDomain = baseDomain

    static func main() {        
        
        let whiteList: [String] = [".DS_Store", "init.swift"]
        let fileManager = FileManager.default
        projectName = setup(step: .nameEntry, defaultValue: projectName)
        bundleDomain = setup(step: .bundleDomainEntry, defaultValue: baseDomain)

        _ = shell("rm", "rf", ".git")
        print("\nRenaming to '\(projectName)'...")
        let enumerator = fileManager.enumerator(at: URL(fileURLWithPath: fileManager.currentDirectoryPath), includingPropertiesForKeys: [.nameKey, .isDirectoryKey])!
        var directories: [URL] = []
        while let itemURL = enumerator.nextObject() as? URL {
            guard !whiteList.contains(itemURL.fileName) else { continue }
            if itemURL.isDirectory {
                directories.append(itemURL)
            } else {
                itemURL.setupForNewProject()
            }
        }

        for dir in directories.reversed() {
            dir.rename(from: baseProjectName, to: projectName)
        }
        //현재 디렉토리 이름 변경
        let currentURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        currentURL.rename(from: baseProjectName, to: projectName)

        let plistPath = defaultPath + "/\(projectName)/info.plist"

        // Info.plist 파일을 딕셔너리로 읽어오기
        guard let plistDict = NSMutableDictionary(contentsOfFile: plistPath) else {
            fatalError("Error: Unable to read Info.plist.")
        }

        let infoSetup: InfoSetup = InfoSetup(plistDict: plistDict)

        infoSetup.kakao()
        infoSetup.google()

        let newPlistDict = infoSetup.create()

        newPlistDict.write(toFile: plistPath, atomically: true)
    }

    static func shell(_ args: String...) -> (output: String, exitCode: Int32) {
        let fileManager = FileManager.default
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.currentDirectoryPath = fileManager.currentDirectoryPath
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return (output, task.terminationStatus)
    }

    static func prompt(message: String) -> String? {
        print("\n" + message)
        let answer = readLine()
        return answer == nil || answer == "" ? nil : answer!
    }

    static func setup(step: SetupStep, defaultValue: String) -> String {
        let result = prompt(message: "\(step.rawValue). " + step.question + " (미입력시: \(defaultValue)).")
        guard let res = result else {
            print(defaultValue)
            return defaultValue
        }
        return res
    }
}

enum ReadLineType: Int {
    case kakao = 1
    case google = 2
    case end = 0
}

enum InsertPosition {
    case front
    case back
}

protocol AuthInfo {
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary
}

class InfoSetup {
    private var plistDict: NSMutableDictionary
    
    init(plistDict: NSMutableDictionary) {
        self.plistDict = plistDict
    }
    
    func kakao() {
        plistDict = KakaoAuthInfo().setup(plistDict: plistDict)
    }
    
    func google() {
        plistDict = GoogleAuthInfo().setup(plistDict: plistDict)
    }
    
    func create() -> NSMutableDictionary {
        return plistDict
    }
}


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

struct KakaoAuthInfo: AuthInfo {
    
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary {
        while true {
            var newPlistDict = addQueriesSchemes(plistDict: plistDict)
            print("[카카오] 네이티브 앱키를 입력해주세요")
            guard let appkey = readLine() else { continue }
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

enum SetupStep: Int {
  case nameEntry = 1
  case bundleDomainEntry
  case companyNameEntry
  
  var question: String {
    switch self {
    case .nameEntry: return "프로젝트 이름을 입력해주세요."
    case .bundleDomainEntry: return "번들 아이디를 입력해주세요"
    case .companyNameEntry: return "Enter the Company name to use on file's headers"
    }
  }
}

extension URL {
  var fileName: String {
    let urlValues = try? resourceValues(forKeys: [.nameKey])
    return urlValues?.name ?? ""
  }
  
  var isDirectory: Bool {
    let urlValues = try? resourceValues(forKeys: [.isDirectoryKey])
    return urlValues?.isDirectory ?? false
  }
  
  func rename(from oldName: String, to newName: String) {
    let fileManager = FileManager.default
    if fileName.contains(oldName) {
      let newName = fileName.replacingOccurrences(of: oldName, with: newName)
      try! fileManager.moveItem(at: self, to: URL(fileURLWithPath: newName, relativeTo: deletingLastPathComponent()))
    }
  }
  
  func replaceOccurrences(of value: String, with newValue: String) {
    guard let fileContent = try? String(contentsOfFile: path, encoding: .utf8) else {
      print("Unable to read file at: \(self)")
      return
    }
    let updatedContent = fileContent.replacingOccurrences(of: value, with: newValue)
    try! updatedContent.write(to: self, atomically: true, encoding: .utf8)
  }
  
  func setupForNewProject() {
    replaceOccurrences(of: myApp.baseProjectName, with: myApp.projectName)
    replaceOccurrences(of: myApp.baseDomain, with: myApp.bundleDomain)
    rename(from: myApp.baseProjectName, to: myApp.projectName)
  }
}