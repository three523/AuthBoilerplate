//
//  File.swift
//  
//
//  Created by 김도현 on 2024/01/25.
//

import Foundation

enum InsertPosition {
    case front
    case back
}

protocol AuthInfo {
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary
}

extension AuthInfo {
    func insertCodeAtLine(filePath: String, lineNumber: Int, codeToInsert: String) {
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                var fileContent = try String(contentsOfFile: filePath)

                var lines = fileContent.components(separatedBy: "\n")

                if lineNumber > 0 && lineNumber <= lines.count {
                    lines.insert(codeToInsert, at: lineNumber - 1)
                    fileContent = lines.joined(separator: "\n")

                    try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)

                    print("코드 삽입 완료 \(lineNumber).")
                } else {
                    print("잘못된 줄 번호.")
                }
            } else {
                try codeToInsert.write(toFile: filePath, atomically: true, encoding: .utf8)
                print("APIKEY 생성 완료")
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func insertCodeIntoFile(filePath: String, keyword: String, codeToInsert: String, insertPosition: InsertPosition) {
        do {
            
            if FileManager.default.fileExists(atPath: filePath) {
                var fileContent = try String(contentsOfFile: filePath)
                
                if let range = fileContent.range(of: keyword) {
                    fileContent.insert(contentsOf: codeToInsert, at: insertPosition == .front ? range.lowerBound : range.upperBound)
                    
                    try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
                    
                    print("코드 삽입 성공.")
                } else {
                    print("키워드를 파일에서 찾을수 없습니다.")
                }
            } else {
                try codeToInsert.write(toFile: filePath, atomically: true, encoding: .utf8)
                print("APIKEY 생성 완료")
            }
        } catch {
            print("Error: \(error)")
        }
            
    }
}
