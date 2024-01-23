//
//  AuthManager.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/23.
//

final class AuthManager {
    
    private var auth: Auth
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    func login(_ authType: AuthType) {
        auth.login(authType)
    }
    
    func logout() {
        auth.logout()
    }
}
