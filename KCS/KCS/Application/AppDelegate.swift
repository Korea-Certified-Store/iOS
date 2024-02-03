//
//  AppDelegate.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import NMapsMap

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let id = Bundle.main.object(forInfoDictionaryKey: "NMAP_CLIENT_ID") as? String {
            NMFAuthManager.shared().clientId = id
        }
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
