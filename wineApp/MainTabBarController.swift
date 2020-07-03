//
//  ViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            tabBar.barTintColor = UIColor.white
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
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
        present(loginController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }

    
    func setupTabBar() {
        
        let reconcileTitle = NSLocalizedString("reconcileTitle", comment: "")
        let producerTitle = NSLocalizedString("producerTitle", comment: "")
        let varietalTitle = NSLocalizedString("varietalTitle", comment: "")
        let drinkByTitle = NSLocalizedString("drinkByTitle", comment: "")
        let searchTitle = NSLocalizedString("searchTitle", comment: "")
        let moreTitle = NSLocalizedString("moreTitle", comment: "")

        
        let drinkByController = createTabController(viewController: DrinkByViewController(),
            selected: #imageLiteral(resourceName: "drinkDark"),
            unselected: #imageLiteral(resourceName: "drinkLight"),
            title: drinkByTitle)


        let producerController = createTabController(viewController: ProducerViewController(),
            selected: #imageLiteral(resourceName: "farmDark"),
            unselected: #imageLiteral(resourceName: "farmLight"),
            title: producerTitle)

        let varietalController = createTabController(viewController: VarietalViewController(),
            selected: #imageLiteral(resourceName: "grapesDark"),
            unselected: #imageLiteral(resourceName: "grapesLight"),
            title: varietalTitle)

        let searchController = createTabController(viewController: SearchViewController(),
            selected: #imageLiteral(resourceName: "search"),
            unselected: #imageLiteral(resourceName: "search"),
            title: searchTitle)
        
        let moreController = createTabController(viewController: MoreMenuViewController(),
            selected: #imageLiteral(resourceName: "more"),
            unselected: #imageLiteral(resourceName: "more"),
            title: moreTitle)

        let reconcileController = createTabController(
            viewController: ReconcileViewController(),
            selected: #imageLiteral(resourceName: "reconcileDark"),
            unselected: #imageLiteral(resourceName: "reconcileLight"),
            title: reconcileTitle)
        
        viewControllers = [searchController,
//                           producerController,
//                           varietalController,
                           drinkByController,
//                           reconcileController,
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

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
