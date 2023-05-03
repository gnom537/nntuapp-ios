//
//  SceneDelegate.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 16.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _: UIWindowScene = scene as? UIWindowScene else { return }
        openFromWidget(urlContexts: connectionOptions.urlContexts, in: scene)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openFromWidget(urlContexts: URLContexts, in: scene)
    }
    
    private func openFromWidget(urlContexts: Set<UIOpenURLContext>, in scene: UIScene) {
        guard
            UserDefaults.standard.bool(forKey: "Entered"),
                let _ = urlContexts.first(where: { $0.url.absoluteString == "nntu.openTimeTable" })
        else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "MainTabBarController") as? UITabBarController else { return }
            
            // tag установлен в storyboard
            vc.selectedIndex = vc.viewControllers?.firstIndex(where: { $0.tabBarItem.tag == 666 }) ?? 1
            
            window.rootViewController = vc
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

