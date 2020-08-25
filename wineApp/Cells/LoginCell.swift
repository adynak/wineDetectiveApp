//
//  LoginCell.swift
//  wineApp
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

class LoginCell: UICollectionViewCell, UITextFieldDelegate {
    
    var productNameView: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = productNameColor
        label.textAlignment = .left
        label.numberOfLines = 3
        label.text = NSLocalizedString("productName", comment: "product name")
        label.font = UIFont(name: "Papyrus", size: 32)
        return label
    }()
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.textContentType = .username
        let placeholderString = NSAttributedString.init(string: NSLocalizedString("loginAccountName", comment: "login prompt for account name"), attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        textField.attributedPlaceholder = placeholderString
        textField.addDoneButtonOnKeyboard()
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        let placeholderString = NSAttributedString.init(string: NSLocalizedString("loginPassword", comment: "login prompt for password"), attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        textField.attributedPlaceholder = placeholderString
        textField.addDoneButtonOnKeyboard()
        return textField
    }()
        
    lazy var rememberMeCheckbox: UIButton = {
        let checkbox = UIButton(type: .custom)
        checkbox.setTitle(NSLocalizedString("buttonRememberMe", comment: "remember username and password on this device"), for: .normal)
        checkbox.setImage(UIImage.init(named: "unchecked"), for: .normal)
        checkbox.setImage(UIImage.init(named: "checked"), for: .selected)
        checkbox.addTarget(self, action: #selector(toggleCheckboxSelection), for: .touchUpInside)
        checkbox.setTitleColor(.black, for: .normal)
        checkbox.titleLabel!.font = UIFont(name: "Verdana", size: 12)
//        checkbox.backgroundColor = .red
        checkbox.titleEdgeInsets = UIEdgeInsets.init(top: 0,left: 12,bottom: 0,right: 0)
        return checkbox
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = loginButtonColor
        button.setTitle(NSLocalizedString("buttonLogin", comment: "the command Log In"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = true
        button.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 20)
        return button
    }()
    
    weak var delegate: LoginControllerDelegate?
        
    @objc func handleLogin() {
        if rememberMeCheckbox.isSelected == true {
            UserDefaults.standard.set(true, forKey: "rememberMe")
            UserDefaults.standard.setUserName(value: emailTextField.text!)
            UserDefaults.standard.setUserPword(value: passwordTextField.text!)
        } else {
            UserDefaults.standard.setUserName(value: "")
            UserDefaults.standard.setUserPword(value: "")
            UserDefaults.standard.set(false, forKey: "rememberMe")
        }
        delegate?.finishLoggingIn(userName: emailTextField.text!, userPword: passwordTextField.text!)
    }
    
    @objc func toggleCheckboxSelection(_ sender: UIButton) {
//        if !sender.isSelected {
//            if UserDefaults.contains("rememberMe"){
//                UserDefaults.standard.set(true, forKey: "rememberMe")
//            }
//            print("selected")
//        } else {
//            if UserDefaults.contains("rememberMe"){
//                UserDefaults.standard.set(false, forKey: "rememberMe")
//            }
//            print("deselected")
//        }
        sender.isSelected = !sender.isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        emailTextField.text = "al00p"
//        passwordTextField.text = "Genesis13355Tigard"
        
        if UserDefaults.standard.getRememberMe() {
            rememberMeCheckbox.isSelected = true
            emailTextField.text = UserDefaults.standard.getUserName()
            passwordTextField.text = UserDefaults.standard.getUserPword()
        } else {
            rememberMeCheckbox.isSelected = false
        }

        if ((emailTextField.text!.isEmpty) || (passwordTextField.text?.isEmpty) != nil) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
        addSubview(productNameView)

        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(rememberMeCheckbox)
        addSubview(loginButton)
        
        rememberMeCheckbox.setImage(UIImage.init(named: "unchecked"), for: .normal)

        _ = productNameView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -340, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 160)
        productNameView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -240, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = emailTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 28, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = rememberMeCheckbox.anchor(passwordTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 25)

        
        _ = loginButton.anchor(rememberMeCheckbox.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}
