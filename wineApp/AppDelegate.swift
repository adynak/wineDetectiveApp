//
//  AppDelegate.swift
//  Wine Detective
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//
//
//  git update-index --skip-worktree /wineApp.xcodeproj/project.pbxproj

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        print("didFinishLaunchingWithOptions")
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(r: 255, g: 255, b: 255),
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UINavigationBar.appearance().barTintColor = UIColor(r: 61,  g: 91,  b: 151) // background
        UINavigationBar.appearance().tintColor =    UIColor(r: 255, g: 255, b: 255) // buttons and icons
        UINavigationBar.appearance().prefersLargeTitles = false

        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 14)!,
                NSAttributedString.Key.foregroundColor : UIColor.white,
            ], for: .normal)
        
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "userPword")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.set(true, forKey: "showBarcode")

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height + 50
        let frame = CGRect.init(x: 0, y: 0, width: width, height: height)

        window = UIWindow(frame: frame)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
//        window?.rootViewController = MainNavigationController()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        return true
    }

    var enableAllOrientation = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (enableAllOrientation == true){
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
        UserDefaults.standard.setIsLoggedIn(value: false)
    }


}

