# 로그인 보일러 템플릿
**아직 완벽하지 않아 직접 수정해줘야하는 부분이 있음**

매번 소셜로그인 기능을 반복적으로 구현할 필요가 없도록 기본 셋팅 템플릿 구현
애플은 테스트를 위해선 애플 개발자 계정이 가입되어있어야 하기때문에 제외시킴
현재 **구글, 카카오** 기능 구현

## 기본 셋팅 방법
터미널에서 **./init** 입력시 기본 
프로젝트 이름, 번들 아이디, 카카오 기본 셋팅, 구글 기본 셋팅을 설정할 수 있도록 구현함

## AuthManager
아직 기능이 덜 완성되어서 카카오 APIKEY는 AppDelegate에 직접 입력해줘야함
AuthManager를 통해 기본 로그인, 로그아웃 기능 구현
사용 예시
```swift
    @IBAction func kakaoLogin(_ sender: Any) {
        authManager.login(.kakao)
    }
    @IBAction func googleLogin(_ sender: Any) {
        authManager.login(.google)
    }
    @IBAction func logout(_ sender: Any) {
        authManager.logout()
    }
```

# 참고
https://github.com/rootstrap/ios-base 기본 스크립트 작성 참고
