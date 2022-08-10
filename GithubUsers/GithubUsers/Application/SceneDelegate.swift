//
//  SceneDelegate.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoorinator: AppCoordinator?
    private let appDIContainer = AppDIContainer()

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootNaivgationController = UINavigationController()
        window?.rootViewController = rootNaivgationController
        window?.makeKeyAndVisible()
                        
        appCoorinator = AppCoordinator(navigationController: rootNaivgationController, appDIContainer: appDIContainer)
        appCoorinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
