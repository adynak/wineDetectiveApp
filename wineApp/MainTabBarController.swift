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
        
        tabBar.barTintColor = UIColor(r: 61,  g: 91,  b: 151)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let vintageController = createNavController(vc: VintageViewController(),
                                                    selected: #imageLiteral(resourceName: "star_white"),
                                                    unselected: #imageLiteral(resourceName: "star_black"))
        vintageController.title = "Vintage"
        
        let producerController = createNavController(vc: ProducerViewController(),
                                                     selected: #imageLiteral(resourceName: "star_white"),
                                                     unselected: #imageLiteral(resourceName: "star_black"))
        producerController.title = "Producer"
        
        let varietalController = createNavController(vc: VarietalViewController(),
                                                     selected: #imageLiteral(resourceName: "star_white"),
                                                     unselected: #imageLiteral(resourceName: "star_black"))
        varietalController.title = "Varietal"
        
        viewControllers = [producerController, vintageController ,varietalController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
}

extension UITabBarController {
    
    func createNavController(vc: UIViewController, selected: UIImage, unselected: UIImage) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        return navController
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
