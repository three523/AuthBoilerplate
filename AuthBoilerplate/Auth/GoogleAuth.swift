//
//  GoogleAuth.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/23.
//

import UIKit
import GoogleSignIn

class GoogleAuth: Auth {
    weak var presenting: UIViewController?
    var nextAuth: Auth?
    
    init(nextAuth: Auth? = nil, presenting: UIViewController? = nil) {
        self.presenting = presenting
        self.nextAuth = nextAuth
    }
    
    func login(_ authType: AuthType) {
        if authType != .google {
            nextAuth?.login(authType)
            return
        }
        guard let presenting else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { signInResult, error in
            if let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func logout() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            GIDSignIn.sharedInstance.signOut()
            print("구글 로그아웃")
        } else {
            if let nextAuth {
                nextAuth.logout()
            } else {
                print("로그인이 되어있지 않습니다.")
            }
        }
    }
}
