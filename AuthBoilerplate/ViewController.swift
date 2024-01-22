//
//  ViewController.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/21.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var GoogleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func kakaoLoginClick(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        } else {
            var scopes: [String] = ["profile_nickname", "account_email", "name", "openid"]
            UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("test")
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            
                            //do something
                            _ = user
                        }
                    }
                }
            }
        }
    }
    @IBAction func googleLoginClick(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            let profile = signInResult?.user.profile
            print(profile?.name)
            print(profile?.email)
        }
    }
    

}

