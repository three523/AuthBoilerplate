import Foundation

enum ReadLineType: Int {
    case kakao = 1
    case google = 2
    case end = 0
}

let defaultPath = FileManager.default.currentDirectoryPath
let projectName = URL(fileURLWithPath: defaultPath).lastPathComponent
let packagePath = defaultPath + "/Package.swift"
let plistPath = defaultPath + "/\(projectName)/info.plist"
var dependencies = [String]()

func insertCodeIntoFile(filePath: String, keyword: String, codeToInsert: String, insertPosition: InsertPosition) {
    do {
        
        if FileManager.default.fileExists(atPath: filePath) {
            var fileContent = try String(contentsOfFile: filePath)
            
            if let range = fileContent.range(of: keyword) {
                fileContent.insert(contentsOf: codeToInsert, at: insertPosition == .front ? range.lowerBound : range.upperBound)
                
                try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
                
                print("코드 삽입 성공.")
            } else {
                print(keyword)
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

func shell(_ args: String...) -> (output: String, exitCode: Int32) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.currentDirectoryPath = defaultPath
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    return (output, task.terminationStatus)
}

func addPackage(packages: [String], librayNames:[String]) {
    var dependenciesPackageCode = ""
    var dependenciesTargetCode = ""
    for package in packages {
        dependenciesPackageCode += "\n\t\t\(package)"
    }
    for librayName in librayNames {
        dependenciesTargetCode += "\"\(librayName)\","
    }
    var dependenciesCode = """
    \n\tdependencies: [\(dependenciesPackageCode)
    ],
    """
    var targetCode = """
    .target(
    \t\t\tname: \"\(projectName)\",
    \t\t\tdependencies: [\(dependenciesTargetCode)]),\n\t\t
    """
    insertCodeIntoFile(filePath: packagePath, keyword: "\(projectName)\",", codeToInsert: dependenciesCode, insertPosition: .back)
    insertCodeIntoFile(filePath: packagePath, keyword: ".executa", codeToInsert: targetCode, insertPosition: .front)
    
    shell("swift", "package", "update")
}

let packages = [".package(url: \"https://github.com/Alamofire/Alamofire.git\", .branch(\"master\")),",
".package(url: \"https://github.com/google/GoogleSignIn-iOS\", .upToNextMajor(from: \"7.0.0\"))"]

let librayNames = ["KakaoSDK", "GoogleSignIn"]
addPackage(packages: packages, librayNames: librayNames)

// Info.plist 파일을 딕셔너리로 읽어오기
//guard var plistDict = NSMutableDictionary(contentsOfFile: plistPath) else {
//    fatalError("Error: Unable to read Info.plist.")
//}
//
//var infoSetup: InfoSetup = InfoSetup(plistDict: plistDict)
//
//while true {
//    print("소셜 로그인을 선택해주세요 (숫자를 입력해주세요)")
//    print("1.kakao 2.google 9.리셋 0.종료")
//    guard let type = Int(readLine() ?? ""),
//          let readLienType = ReadLineType(rawValue: type) else { continue }
//    if readLienType == .end { break }
//    else if readLienType == .kakao {
//        infoSetup.kakao()
//        continue
//    } else if readLienType == .google {
//        infoSetup.google()
//        continue
//    }
//    break
//}
//
//let newPlistDict = infoSetup.create()
//
//newPlistDict.write(toFile: plistPath, atomically: true)
