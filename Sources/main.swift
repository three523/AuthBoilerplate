//
//  main.swift
//  Setup
//
//  Created by 김도현 on 2024/01/29.
//

import Foundation

import Foundation

enum ReadLineType: Int {
    case kakao = 1
    case google = 2
    case end = 0
}

let defaultPath = FileManager.default.currentDirectoryPath
let projectName = URL(fileURLWithPath: defaultPath).lastPathComponent
let plistPath = defaultPath + "/\(projectName)/info.plist"

// Info.plist 파일을 딕셔너리로 읽어오기
guard var plistDict = NSMutableDictionary(contentsOfFile: plistPath) else {
    fatalError("Error: Unable to read Info.plist.")
}

var infoSetup: InfoSetup = InfoSetup(plistDict: plistDict)

infoSetup.kakao()
infoSetup.google()

let newPlistDict = infoSetup.create()

newPlistDict.write(toFile: plistPath, atomically: true)
