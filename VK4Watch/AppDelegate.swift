//
//  AppDelegate.swift
//  VK4Watch
//
//  Created by Максим on 04.06.2021.
//

import UIKit
import WatchConnectivity
import SwiftyVK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, SwiftyVKAuthorizatorDelegate, SwiftyVKPresenterDelegate, SwiftyVKSessionDelegate {
    let defaults = UserDefaults.standard
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
        defaults.set(info["access_token"], forKey: "token")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
        defaults.set(info["access_token"], forKey: "token")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
        defaults.set("", forKey: "token")
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        let scopes: Scopes = [.offline,.friends,.wall]
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }
   
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }else{
            print("WCSession activated with state \(activationState.rawValue)")
        }
    }
   
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWC()
        VK.setUp(appId: "7872799", delegate: self)
        return true
    }
    func setupWC() {
        if WCSession.isSupported(){
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

