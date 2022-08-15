# ⚒ Github 사용자 리스트 앱

> 과제 수행 기간: 2022.08.10 ~ 2022.08.15 <br>

---

# 📋 목차
- [프로젝트 실행화면](#-프로젝트-실행화면)
- [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
- [키워드](#-키워드)
- [App 구조](#-App-구조)
- [고민한 점 및 트러블 슈팅](#-고민한-점-및-트러블-슈팅)

---

## 📺 프로젝트 실행화면
|메인페이지|
|--|
|<img src="https://i.imgur.com/CaSRMzw.gif">|

|내팔로잉|
|--|
|<img src="https://i.imgur.com/5Z32zwM.gif">|

|상세페이지|
|--|
|<img src="https://i.imgur.com/pKoy3oN.gif">|

---

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-blue)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4-yellow)]()
- [![iOS](https://img.shields.io/badge/iOS-13.0-red)]()
- [![Swift Package Manager](https://img.shields.io/badge/SwiftPackageManager--red)]()
- [![RxSwift](https://img.shields.io/badge/RxSwift-6.5-orange)]()
- [![RealmSwift](https://img.shields.io/badge/RealmSwift-10.28-orange)]()
- [![Snapkit](https://img.shields.io/badge/Snapkit-5.6-orange)]()

---

## 🔑 키워드
- `DIContainer`
- `Dependency Injection`
- `Clean Architecture`
- `MVVM`
- `Coordinator`
- `Reactive Programming`
- `RxSwift`
- `ARC`
- `Test Double`
- `상태 검증 테스트`
- `행위 검증 테스트`
- `Snapkit`
- `Realm`

---

## App 구조

### DIContainer, Coordinator
<img src="https://i.imgur.com/Y1NYHlS.png" width="600">

### CleanArchitecture, MVVM
<img src="https://i.imgur.com/YaHuKoq.png" width="600">

### 선택한 이유
- 기존 MVVM의 경우 MVC보다는 계층이 분리되고, 객체들의 관심사가 분리되지만 그럼에도 ViewModel의 역할이 커지는 문제가 발생했습니다.
- CleanArchitecture를 통해 Layer를 한층 더 나누어 주면서 계층별로 관심사가 나누어지게 되고, 자연스럽게 각각의 객체들의 역할이 분명하게 나누어질 수 있습니다.
- 이로 인해 객체들의 결합도가 낮아지고, 응집도는 높아지면서 문제가 발생했을 때 쉽게 찾을 수 있고 해당 부분만 수정이 가능해지면서 유지보수적인 측면에서 상당한 이점을 갖을 수 있다고 생각합니다.
- DIContainer를 통한 의존성 주입으로 ViewModel, UseCase, Repository, Storage에 대한 테스트가 용이해집니다.
- 하지만, 앱의 복잡도가 높아지기 때문에 복잡도를 낮출 수 있는 방법을 생각해 보아야할 것 같습니다.

--- 

## 고민한 점, 트러블 슈팅

### 인스턴스의 RC관리
- 최상위 AppDIContainer에서 모든 의존성을 관리하고, 하위에 주입해주는 방법을 사용했습니다.
- 클래스를 전달하다보니, 전달할때마다 RC가 늘어나는 문제가 있었습니다.
- 외부에서 주입받은 의존성의 경우 상위 의존성이 먼저 해제될 일이 없다고 생각하여 unowned를 적용해 불필요한 RC를 늘리지 않고 의존성을 주입해주었습니다.

### 내 팔로잉 페이지 Pull To Refresh 제거
- 리스트 공통 요구사항으로 Pull To Refresh가 있었습니다.
- 기존엔 내 팔로잉의 경우에 Storage에서 Observable<[User]> 타입으로 전달해주는 방식으로 설계 했었습니다.
- 하지만 해당 페이지의 경우 순수하게 LocalDB만 사용하기 때문에 Storage로 부터 Subject를 반환 받아 바인딩을 시켜놓는 방식으로 진행하였습니다.
- 그렇기 때문에, DB가 바뀔때마다 자동으로 Subject를 반환받아 View에 뿌려주기 때문에 Pull To Refresh가 필요 없어져서 제거하였습니다.

### DiffableDataSource 사용
- 요구사항에 최소 지원 버전이 iOS 13.0인 것을 보고 13.0에 업데이트 되었던UIDiffableDataSource를 사용해보았습니다.
- 개인적으로는 UIDiffableDataSource 자체가 Reactive하기 때문에 RxSwift와 같이 쓰는것이 조금은 어색했던 것 같습니다.
- 예를 들어 modelSelected를 사용하려면 기존 TableView, CollectionView가 바인딩 되어있어야 사용할 수 있는데 UIDiffableDataSource을 쓰다보니 해당 메서드를 사용하지 못했던 부분 등이 있을 것 같습니다.
- 하지만 UIDiffableDataSource 자체로는 이전 dataSource와는 비교도 안될 정도로 좋았던 것 같습니다. 

### subscribe안의 코드들을 추상화 할 것인가?
- 각 VC의 `bind()` 메서드의 subscribe안쪽의 코드들을 VC 내부에 메서드로 추상화를 진행할 것인가라는 고민을 했었습니다.
- 메서드로 빼주는 경우와 그렇지 않은 경우를 생각해 보았을 때, 빼주는 경우엔 메서드 자체로는 한층 더 보기 편해진 느낌이 있었지만 아무래도 코드 점핑이 이루어지기 때문에 그렇지 않은 경우와 비교했을 때 비슷한 느낌이 들었습니다.
- 코드양이 조금 많은 경우엔 빼주었고, 많지 않은 경우엔 메서드로 빼주지 않고 진행하였습니다.

### ImageDownload 작업을 ImageView의 Extension으로 진행한 이유
- MVVM 패턴의 논리상 ImageDownload 같은 작업의 경우 ViewModel에서 진행하는 것이 맞다고 생각하였습니다.
- 하지만, 두가지 이유로 ImageView의 Extension으로 진행하였습니다. 
- 첫번째로 ViewModel에 UI와 관련된 프레임워크나 라이브러리가 들어가는 것에 대한 부분이 뭔가 안티패턴이 될 수 있겠다 라는 생각이 들었습니다.
- 두번째로 Cell이 만들어지는 시점. 즉, dequeueResuableCell 시점에서 Image를 Download 한다면, 이미지가 다 다운로드 받아지기전 까지는 해당 Cell 화면의 로드 자체가 늦어버릴 수 있기 때문에 Cell 안에서 이미지를 다운받는 것이 맞다고 생각하였습니다.

### ImageCacheManager를 싱글턴으로 사용한 이유
- NSCache는 초기화 되지 않고 계속해서 메모리에 올라가있어야 정상적인 캐싱작업을 할 수 있다고 생각하였습니다.

### Repository, UseCase를 Local과 Remote로 분리할 것인가?
- 현재 UserRepository와 UserUseCase 객체 안에 User 관련 Local, Remote 메서드들이 모두 존재하고있습니다.
- 분리의 기준을 User라는 API, Storage 즉 Service로 나누어줄지, Local, Remote 같이 기능의 역할을 기준으로 나눌지 고민하였습니다.
- 결국엔 Service 기준으로 하여 Local, Remote 메서드들이 모두 하나의 Repo, UseCase에 존재하는 것으로 진행하였습니다.

### MockUserRepository, Test Double
- 현재 MockUserRepository의 경우 상태검증과 행위검증 모두를 진행하고 있습니다.
- 상태검증인 경우 Stub, 행위검증인 경우 Mock Test Double을 사용해야 하는데 이런 경우엔 어떤식으로 해야할지 고민하였습니다.
- 우선은 Mock이라고 네이밍 하였습니다. 이런 경우가 나온 것으로 봐서 현재 테스트 코드가 좋은 코드가 아닌 것 같습니다. 해당 부분의 경우 좀 더 공부가 필요할 것 같습니다😭

---

감사합니다!
