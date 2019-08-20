//
//  AppDelegate.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = MLMainViewController()
        let logViewController = MLGameLogViewController()
        let settingsViewController = MLSettingsViewController()
        
        let navigationController1 = UINavigationController(rootViewController: mainViewController)
        navigationController1.tabBarItem = UITabBarItem(title: "MLChess", image: UIImage(named: "first"), tag: 0)
        let navigationController2 = UINavigationController(rootViewController: logViewController)
        navigationController2.tabBarItem = UITabBarItem(title: "Logs", image: UIImage(named: "data"), tag: 1)
        let navigationController3 = UINavigationController(rootViewController: settingsViewController)
        navigationController3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 3)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController1,navigationController2,navigationController3]
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
 
        application.isIdleTimerDisabled = true
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let settings = [
            "testMode" : false,
            "simulationMode" : false,
            "userColor" : MLPieceColor.white.rawValue,
            "whiteCalcDuration" : 40,
            "blackCalcDuration" : 40,
            "whiteStrategy" : MLChessStrategy.Numerator.rawValue,
            "blackStrategy" : MLChessStrategy.Numerator.rawValue,
            "whiteSimulationDepth" : MLChessSimulationDepth.Long.rawValue,
            "blackSimulationDepth" : MLChessSimulationDepth.Long.rawValue,
            "whiteStateEvaluation" : MLChessStateEvaluation.PawnUnits.rawValue,
            "blackStateEvaluation" : MLChessStateEvaluation.PawnUnits.rawValue,
            "whiteRolloutPolicy" : MLChessRolloutPolicy.Random.rawValue,
            "blackRolloutPolicy" : MLChessRolloutPolicy.Random.rawValue,
            "mctsExplorationCoefficient" : sqrt(2)
            ] as [String : Any]
        
        UserDefaults.standard.register(defaults: settings)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

