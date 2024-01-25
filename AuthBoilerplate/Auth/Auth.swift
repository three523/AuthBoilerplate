//
//  Auth.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/23.
//

import Foundation

enum AuthType {
    case kakao
    case google
}

protocol Auth {
    var nextAuth: Auth? { get set }
    func login(_ authType: AuthType) -> Void
    func logout() -> Void
}
