//
//  MainTabBarController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            tabBar.barTintColor = UIColor.white
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
            
            if !UserDefaults.standard.getiCloudStatus() {
                Alert.noIcloudAlert(on: self)
            }
            
            setupTabBar()
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
           return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: {
        })
    }

    
    func setupTabBar() {
        
        let drinkByTitle = NSLocalizedString("titleDrinkBy", comment: "Navigation Bar menu title: Drink By.  This will display a list of wines sorted by when they should be consumed, from sooner to later.")
        let searchTitle = NSLocalizedString("titleSearch", comment: "navigation title: search")
        let moreTitle = NSLocalizedString("titleMore", comment: "navigation title: More")

        
        let drinkByController = createTabController(viewController: DrinkByViewController(),
            selected: #imageLiteral(resourceName: "drinkDark"),
            unselected: #imageLiteral(resourceName: "drinkLight"),
            title: drinkByTitle)


//        let producerController = createTabController(viewController: ProducerViewController(),
//            selected: #imageLiteral(resourceName: "farmDark"),
//            unselected: #imageLiteral(resourceName: "farmLight"),
//            title: producerTitle)
//
//        let varietalController = createTabController(viewController: VarietalViewController(),
//            selected: #imageLiteral(resourceName: "grapesDark"),
//            unselected: #imageLiteral(resourceName: "grapesLight"),
//            title: varietalTitle)

        let searchController = createTabController(viewController: SearchViewController(),
            selected: #imageLiteral(resourceName: "search"),
            unselected: #imageLiteral(resourceName: "search"),
            title: searchTitle)
        
        let moreController = createTabController(viewController: MoreMenuViewController(),
            selected: #imageLiteral(resourceName: "more"),
            unselected: #imageLiteral(resourceName: "more"),
            title: moreTitle)

//        let locationController = createTabController(
//            viewController: LocationViewController(),
//            selected: #imageLiteral(resourceName: "locationDark"),
//            unselected: #imageLiteral(resourceName: "locationLight"),
//            title: locationTitle)
        
        viewControllers = [searchController,
//                           producerController,
//                           varietalController,
                           drinkByController,
//                           locationController,
                           moreController]
        
//        guard let items = tabBar.items else { return }
        
        var offset: CGFloat = 0.0
        if #available(iOS 11.0, *), traitCollection.horizontalSizeClass == .regular {
            offset = 0.0
        }
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
                item.titlePositionAdjustment = UIOffset(horizontal:0, vertical:0)
            }
        }
    }
    
}

extension UITabBarController {
    
    func createTabController(viewController: UIViewController, selected: UIImage, unselected: UIImage, title: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        navController.tabBarItem.title = title
        return navController
    }
}
