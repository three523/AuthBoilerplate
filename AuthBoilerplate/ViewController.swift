//
//  ViewController.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/21.
//

import UIKit
import KakaoSDKAuth

class ViewController: UIViewController {

    private lazy var authManager: AuthManager = AuthManager(auth: KakaoAuth(nextAuth: GoogleAuth(presenting: self)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func kakaoLogin(_ sender: Any) {
        authManager.login(.kakao)
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        authManager.login(.google)
    }
    
    @IBAction func logout(_ sender: Any) {
        authManager.logout()
    }
}
