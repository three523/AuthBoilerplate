//
//  File 4.swift
//  
//
//  Created by 김도현 on 2024/01/25.
//

import Foundation

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
