//
//  Alert.swift
//  wineApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    
    private static func showBasicAlert(on vc: UIViewController,
                                       with title:String,
                                       message: String,
                                       buttonText: String = "OK"){
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonText,
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)

        DispatchQueue.main.async {
            vc.present(alert,animated: true)
//            vc.navigationController?.popViewController(animated: true)

            
        }
        
    }
    
    static func showAddBottleAlert(on vc: UIViewController){
        showBasicAlert(on: vc,
                       with: "Add New Bottle",
                       message: "add bottle requested",
                       buttonText: "Add")
    }
    
    static func showActionMenuAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Action Menu", message: "action menu requested")
        
    }

    static func showLoginCredentialsAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Login", message: "User Name and Password are required")
    }

    
    static func showEmailFailedsAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "eMail", message: "Email is not configured to work with this application.")
    }

    static func showAPIFailedsAlert(on vc: UIViewController){
        let title = NSLocalizedString("dataLoadFailedTitle", comment: "")
        let message = NSLocalizedString("dataLoadFailedMessage", comment: "")
        showBasicAlert(on: vc, with: title, message: message)
    }

    static func noInternetAlert(on vc: UIViewController){
        let title = NSLocalizedString("noInternetTitle", comment: "")
        let message = NSLocalizedString("noInternetMessage", comment: "")
        showBasicAlert(on: vc, with: title, message: message)
    }

    
    
    static func showWineDetailAlert(on vc: UIViewController, with bottleInfo:String){
        showBasicAlert(on: vc,
                       with: "Wine Details",
                       message: "wine detail requested for \n" + bottleInfo )
    }

}
