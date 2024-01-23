//
//  AuthManager.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/23.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

final class AuthManager {
    
    weak var presenting: UIViewController?
    
    init(presenting: UIViewController) {
        self.presenting = presenting
    }
    
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    UserApi.shared.me { user, error in
                        print(user?.kakaoAccount?.name,
                              user?.kakaoAccount?.email,
                              user?.kakaoAccount?.profile?.nickname)
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount() { (_, error) in
                if let error = error {
                    print(error)
                }
                else {
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            
                            //do something
                            UserApi.shared.me { user, error in
                                print(user?.kakaoAccount?.name,
                                      user?.kakaoAccount?.email,
                                      user?.kakaoAccount?.profile?.nickname)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func googleLogin() {
        guard let presenting else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { signInResult, error in
            guard error == nil else { return }
            let profile = signInResult?.user.profile
            print(profile?.name)
            print(profile?.email)
            signInResult?.user.profile
        }
    }
    
    func logout() {
        if AuthApi.hasToken() {
            UserApi.shared.unlink { error in
                if let error {
                    print(error.localizedDescription)
                    print("카카오 로그아웃 에러")
                } else {
                    print("카카오 로그아웃 완료")
                }
            }
        } else if GIDSignIn.sharedInstance.currentUser != nil {
            GIDSignIn.sharedInstance.signOut()
            print("구글 로그아웃 완료")
        } else {
            print("로그인 되어있지 않습니다.")
        }
    }
}
