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
                                       buttonText: String = NSLocalizedString("alertTextHelp", comment: "alert button: OK")
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
        let title = NSLocalizedString("alertTextDataLoadFailedTitle", comment: "alert title: data download failed")
        let message = NSLocalizedString("alertTextDataLoadFailedMessage", comment: "alert text: data download failed message, maybe the userID and/or password was invalid")
        showBasicAlert(on: vc, with: title, message: message)
    }

    static func noInternetAlert(on vc: UIViewController){
        let title = NSLocalizedString("alertTextNoInternetTitle", comment: "alert title: internet connection failed")
        let message = NSLocalizedString("alertTextNoInternetMessage", comment: "alert text: not connected to the internet")
        showBasicAlert(on: vc, with: title, message: message)
    }
    
    static func noIcloudAlert(on vc: UIViewController){
        let title = NSLocalizedString("alertTextNoIcloudTitle", comment: "alert title: iCloud")
        let message = NSLocalizedString("alertTextNoIcloudMessage", comment: "alert text: connect to iCloud account")
        showBasicAlert(on: vc, with: title, message: message)
    }
    
    static func throttleRefreshAlert(on vc: UIViewController){
        let title = NSLocalizedString("alertTextThrottleRefreshTitle", comment: "alert title: seriously...")
        let message = NSLocalizedString("alertTextThrottleRefreshMessage", comment: "alert text: pull to refresh rules")
        showBasicAlert(on: vc, with: title, message: message)
    }

}
