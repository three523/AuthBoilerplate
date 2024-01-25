//
//  KakaoAuth.swift
//  AuthBoilerplate
//
//  Created by 김도현 on 2024/01/23.
//

import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuth: Auth {
    var nextAuth: Auth?
    
    init(nextAuth: Auth? = nil) {
        self.nextAuth = nextAuth
    }
    
    func login(_ authType: AuthType) {
        if authType != .kakao {
            nextAuth?.login(authType)
            return
        }
        if (UserApi.isKakaoTalkLoginAvailable()) {
            kakaoTalkLogin()
        } else {
            kakaoWebLogin()
        }
    }
    
    func logout() {
        if AuthApi.hasToken() {
            UserApi.shared.logout { error in
                if let error {
                    print(error.localizedDescription)
                    print("카카오 로그아웃 에러")
                } else {
                    print("카카오 로그아웃 완료")
                }
            }
        } else {
            if let nextAuth {
                nextAuth.logout()
            } else {
                print("로그인이 되어있지 않습니다.")
            }
        }
    }
    
    private func kakaoWebLogin() {
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
    
    private func kakaoTalkLogin() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                UserApi.shared.me { user, error in
                    print(user?.kakaoAccount?.name,
                          user?.kakaoAccount?.email,
                          user?.kakaoAccount?.profile?.nickname)
                }
            }
        }
    }
}
