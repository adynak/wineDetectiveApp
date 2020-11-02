//
//  AppDelegate.swift
//  WineApp
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "WineGPS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    static var managedContext: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .default).async {
            CKContainer.default().accountStatus { (accountStatus, error) in
                if accountStatus == .available {
                    UserDefaults.standard.set(true, forKey: "iCloudAvailable")
                } else {
                    UserDefaults.standard.set(false, forKey: "iCloudAvailable")
                }
            }
            group.leave()
        }
        group.wait()
        
        print("didFinishLaunchingWithOptions")
                
        let attrs = [
            NSAttributedString.Key.foregroundColor: foregroundColor,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().tintColor = buttonTintColor
        UINavigationBar.appearance().prefersLargeTitles = false

        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 14)!,
                NSAttributedString.Key.foregroundColor : foregroundColor,
            ], for: .normal)
        
//        if let appDomain = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: appDomain)
//        }

        UserDefaults.standard.setIsLoggedIn(value: false)
        if !UserDefaults.contains("showBarcode"){
            UserDefaults.standard.set(true, forKey: "showBarcode")
        }
        if !UserDefaults.contains("showPages"){
            UserDefaults.standard.set(true, forKey: "showPages")
        }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height + 50
        let frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        window = UIWindow(frame: frame)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
        
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
        // print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // print("applicationWillTerminate")
        UserDefaults.standard.setIsLoggedIn(value: false)
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        // Determine who sent the URL.
//        let sendingAppID = options[.sourceApplication]
        print("link from widget")

        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let urlPath = components.path,
            let params = components.queryItems else {
                return false
        }
        
        if let varietalName = params.first(where: { $0.name == "varietal" })?.value {
            print("urlPath = \(urlPath)")
            print("varietalName = \(varietalName)")
            print("link from widget")
            
            let varietalController = WidgetVarietalViewController()
            varietalController.widgetVarietal = varietalName
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height + 0
            let frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            
            window = UIWindow(frame: frame)
            window?.makeKeyAndVisible()
            window?.rootViewController = MainTabBarController()
            return true
        } else {
            print("Photo index missing")
            return false
        }
    }

}

