//
//  ViewController.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var GoogleLoginButton: UIButton!
    
    private lazy var authManager: AuthManager = AuthManager(presenting: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func kakaoLoginClick(_ sender: Any) {
        authManager.kakaoLogin()
    }
    @IBAction func googleLoginClick(_ sender: Any) {
        authManager.googleLogin()
    }
    @IBAction func logoutClick(_ sender: Any) {
        authManager.logout()
    }
}
