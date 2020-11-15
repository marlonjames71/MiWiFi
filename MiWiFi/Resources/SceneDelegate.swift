//
//  SceneDelegate.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import TouchDoll

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }


		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		#if DEBUG
//		window?.showTouches()
		#endif
		window?.windowScene = windowScene
		window?.rootViewController = createTabBar()
		window?.tintColor = .miGlobalTint
		window?.makeKeyAndVisible()
	}

	func createWIFITableNC() -> UINavigationController {
		let wifiTableVC = WiFiTableVC()
		wifiTableVC.title = "WiFi List"
		wifiTableVC.tabBarItem = UITabBarItem(title: "WiFi List", image: UIImage(systemName: "wifi"), tag: 0)

		let navController = UINavigationController(rootViewController: wifiTableVC)
		navController.navigationBar.tintColor = .miGlobalTint

		return navController
	}

	func createWIFISettingsNC() -> UINavigationController {
		let wifiSettingsVC = WiFiSettingsVC()
		wifiSettingsVC.title = "Settings"
		wifiSettingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "slider.horizontal.3"), tag: 1)

		let navController = UINavigationController(rootViewController: wifiSettingsVC)
		navController.navigationBar.tintColor = .miGlobalTint

		return navController
	}

	func createTabBar() -> UITabBarController {
		let tabBar = UITabBarController()
		UITabBar.appearance().tintColor = .miGlobalTint
		tabBar.viewControllers = [createWIFITableNC(), createWIFISettingsNC()]

		return tabBar
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}
}

