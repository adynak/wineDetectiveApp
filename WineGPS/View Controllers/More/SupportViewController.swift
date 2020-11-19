//
//  SupportViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

import MessageUI


class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let cellID = "cell123"
        
    var tableView: UITableView!
    
    let tableHeaderHeight = 40
    let tableRowHeight = 40
    let tableFooterHeight = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = moreViewBackgroundColor
        configureUI()

    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(self.tableRowHeight)
        
        tableView.tableFooterView = UIView()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MoreMenuCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        
        let tableFrameHeight = calcTableHeight()
        let height = CGFloat(tableFrameHeight)
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
        tableView.frame = frame
        tableView.layer.cornerRadius = CGFloat(0)
        
    }
    
    func configureUI() {
        configureTableView()
        
        navigationItem.title = NSLocalizedString("titleSupport", comment: "navigation title : Support")

    }
    
    func calcTableHeight() -> Int{
        let topOffset = UIApplication.shared.windows[0].safeAreaInsets.top

        var numberOfRows: Int = 0
        let numberofHeaders = SupportMenuSections.allCases.count
        for (_,section) in SupportMenuSections.allCases.enumerated(){
            numberOfRows += section.sectionRowCount
        }
        let spaceForHeader = numberofHeaders * tableHeaderHeight
        let spaceForFooter = numberofHeaders * tableFooterHeight
        let spaceForRows = numberOfRows * tableRowHeight
        return spaceForHeader + spaceForFooter + spaceForRows + Int(topOffset)
    }
    
}

extension SupportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SupportMenuSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SupportMenuSections(rawValue: section) else {return 0}
        
        switch section {
            case .Contact:
                return ContactNames.allCases.count
            case .Version:
                return VersionOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = moreViewBackgroundColor
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        title.text = SupportMenuSections(rawValue: section)?.description
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        view.layer.cornerRadius = 0
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = moreViewBackgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell  = tableView.cellForRow(at: indexPath)
//        cell!.contentView.backgroundColor = .white
//    }

//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell  = tableView.cellForRow(at: indexPath)
//        cell!.contentView.backgroundColor = .white
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SupportMenuSections(rawValue: indexPath.section) else {return}
        
        switch section {
            case .Contact:
                switch ContactNames(rawValue: indexPath.row)!.controller{
                    case "sendEmail":
                        sendEmail()
                    default:
                        return
                }
            default:
                return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MoreMenuCell
        
        cell.selectionStyle = .none
        
        guard let section = SupportMenuSections(rawValue: indexPath.section) else {return UITableViewCell()}
        
        switch section {
            case .Contact:
                let report = ContactNames(rawValue: indexPath.row)
                cell.sectionType = report
                cell.moreImageView.image = UIImage(named:ContactNames(rawValue:indexPath.row)!.thumbnail,in: Bundle(for: type(of:self)),compatibleWith: nil)
            case .Version:
                let appOption = VersionOptions(rawValue: indexPath.row)
                cell.moreImageView.image = UIImage(named:VersionOptions(rawValue:indexPath.row)!.thumbnail,in: Bundle(for: type(of:self)),compatibleWith: nil)
                cell.sectionType = appOption
        }
                
        return cell
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let emailBody = DeviceInfo.buldEmailBody()
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([NSLocalizedString("emailContactAddress", comment: "email address for support")])
            mail.setSubject(NSLocalizedString("emailSubject", comment: "email subject"))
            mail.setMessageBody(emailBody, isHTML: true)
            present(mail, animated: true)
        } else {
            Alert.showEmailFailedsAlert(on: self)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
