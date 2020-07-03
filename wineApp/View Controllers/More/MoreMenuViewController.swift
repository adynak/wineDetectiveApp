//
//  ViewController.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit


class MoreMenuViewController: UIViewController {
    
    let cellID = "cell123"
        
    var tableView: UITableView!
//    var userInfoHeader: UserInfoHeader!
    
    let tableHeaderHeight = 40
    let tableRowHeight = 40
    let tableFooterHeight = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:242, g:242, b:247)
        configureUI()

    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MoreMenuCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        
        let tableFrameHeight = calcTableHeight()
        let frame = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: CGFloat(tableFrameHeight))
        
        tableView.frame = frame
        tableView.layer.cornerRadius = CGFloat(10)
        
//        userInfoHeader = UserInfoHeader(frame: frame)
//        tableView.tableHeaderView = userInfoHeader
//        tableView.tableFooterView = UIView()
//        tableView.tableFooterView?.backgroundColor = .red
    }
    
    func configureUI() {
        configureTableView()
        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("moreTitle", comment: "title for reconcile")
        navigationController?.navigationBar.barTintColor = UIColor(r:90,g:115,b:166)
        let logOutBtn = NSLocalizedString("logOutBtn", comment: "")
                
        let cancelButton = UIBarButtonItem(title: logOutBtn,
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(handleLogOut))
        
        navigationItem.leftBarButtonItem = cancelButton    }
    
    func calcTableHeight() -> Int{
        var numberOfRows: Int = 0
        let numberofHeaders = MoreMenuSections.allCases.count
        for (_,section) in MoreMenuSections.allCases.enumerated(){
            numberOfRows += section.sectionRowCount
        }
        let spaceForHeader = numberofHeaders * tableHeaderHeight
        let spaceForFooter = numberofHeaders * tableFooterHeight
        let spaceForRows = numberOfRows * tableRowHeight
        return spaceForHeader + spaceForFooter + spaceForRows
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }

}

extension MoreMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MoreMenuSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MoreMenuSections(rawValue: section) else {return 0}
        
        switch section {
            case .Reports:
                return ReportNames.allCases.count
            case .Settings:
                return AppOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(r:90, g:115, b:166)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .white
        title.text = MoreMenuSections(rawValue: section)?.description
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        view.layer.cornerRadius = 10
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(r:242, g:242, b:247) //white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MoreMenuSections(rawValue: indexPath.section) else {return}

        switch section {
        case .Reports:
            print(ReportNames(rawValue: indexPath.row)!.description)
        case .Settings:
            print(AppOptions(rawValue: indexPath.row)!.description)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MoreMenuCell
        
        guard let section = MoreMenuSections(rawValue: indexPath.section) else {return UITableViewCell()}

        switch section {
            case .Reports:
                let report = ReportNames(rawValue: indexPath.row)
                cell.sectionType = report
            case .Settings:
                let appOption = AppOptions(rawValue: indexPath.row)
                cell.sectionType = appOption
        }
        cell.layer.cornerRadius = 100
                
        return cell
    }
    
}
