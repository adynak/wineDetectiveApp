//
//  Alert.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    
    private static func showBasicAlert(on vc: UIViewController,
                                       with title:String,
                                       message: String,
                                       buttonText: String = NSLocalizedString("alertTextHelp", comment: "alert button text: Help")
        ){
        
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
        
    static func showActionMenuAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Action Menu", message: "action menu requested")
        
    }

    static func showLoginCredentialsAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Login", message: NSLocalizedString("alertTextMissingCredentials", comment: "alert text: Username and password are required"))
    }

    static func showEmailFailedsAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "eMail", message: NSLocalizedString("alertTextEmail", comment: "alert text: email not configured for this application"))
    }

    static func showAPIFailedsAlert(on vc: UIViewController){
        let title = NSLocalizedString("alertTextDataLoadFailedTitle", comment: "alert button text: data download failed title")
        let message = NSLocalizedString("alertTextDataLoadFailedMessage", comment: "alert text: data download failed message")
        showBasicAlert(on: vc, with: title, message: message)
    }

    static func noInternetAlert(on vc: UIViewController){
        let title = NSLocalizedString("alertTextNoInternetTitle", comment: "alert button text: no internet title")
        let message = NSLocalizedString("alertTextNoInternetMessage", comment: "alert text: no internet message")
        showBasicAlert(on: vc, with: title, message: message)
    }

    static func showWineDetailAlert(on vc: UIViewController, with bottleInfo:String){
        showBasicAlert(on: vc,
                       with: NSLocalizedString("alertTextWineDetailsTitle", comment: "alert title: Wine Details"),
                       message: NSLocalizedString("alertTextWineDetailsText", comment: "alert button text: wine details for these bottles") + bottleInfo )
    }

}
