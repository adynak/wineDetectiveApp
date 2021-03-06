//
//  MoreMenuViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit


class MoreMenuViewController: UIViewController {
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("titleMore", comment: "navigation title: More")
        let logOutBtn = NSLocalizedString("buttonLogOut", comment: "button text: Log Out")
                
        let cancelButton = UIBarButtonItem(title: logOutBtn,
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(handleLogOut))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func calcTableHeight() -> Int{
        let topOffset = UIApplication.shared.windows[0].safeAreaInsets.top

        var numberOfRows: Int = 0
        let numberofHeaders = MoreMenuSections.allCases.count
        for (_,section) in MoreMenuSections.allCases.enumerated(){
            numberOfRows += section.sectionRowCount
        }
        let spaceForHeader = numberofHeaders * tableHeaderHeight
        let spaceForFooter = numberofHeaders * tableFooterHeight
        let spaceForRows = numberOfRows * tableRowHeight
        return spaceForHeader + spaceForFooter + spaceForRows + Int(topOffset)
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setWidgetVarietal(value: "")

        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
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
                // lucky for you the last report is the one we want to hide
                if allWine?.missing?.count == 0 {
                    return ReportNames.allCases.count - 1
                } else {
                    return ReportNames.allCases.count
                }
            case .Settings:
                return AppOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = moreViewBackgroundColor
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        title.text = MoreMenuSections(rawValue: section)?.description
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
        guard let section = MoreMenuSections(rawValue: indexPath.section) else {return}
        
        let moreController: UITableViewController
        let supportController : UIViewController

        switch section {
        case .Reports:
            switch ReportNames(rawValue: indexPath.row)!.controller{
                case "producer":
                    moreController = ProducerViewController()
                case "varietal":
                    moreController = VarietalViewController()
                case "location":
                    moreController = LocationViewController()
                case "missingDates":
                    moreController = MissingDrinkByViewController()
                default:
                    return
                }
            navigationController?.pushViewController(moreController, animated: true)
        case .Settings:
            switch AppOptions(rawValue: indexPath.row)!.controller{
            case "support":
                supportController = SupportViewController()
                navigationController?.pushViewController(supportController, animated: true)
            default:
                return
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MoreMenuCell
        
        cell.selectionStyle = .none
        
        guard let section = MoreMenuSections(rawValue: indexPath.section) else {return UITableViewCell()}
        
        switch section {
            case .Reports:
                let report = ReportNames(rawValue: indexPath.row)
                cell.sectionType = report
                cell.moreImageView.image = UIImage(named:ReportNames(rawValue:indexPath.row)!.thumbnail,in: Bundle(for: type(of:self)),compatibleWith: nil)
            case .Settings:
                let appOption = AppOptions(rawValue: indexPath.row)
                cell.sectionType = appOption
                cell.moreImageView.image = UIImage(named:AppOptions(rawValue:indexPath.row)!.thumbnail,in: Bundle(for: type(of:self)),compatibleWith: nil)
        }
        return cell
    }
    
}
