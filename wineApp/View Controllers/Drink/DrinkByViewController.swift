//this is closest
//
//  ViewController.swift
//  SearchBar
//
//  Created by Stephen Dowless on 6/25/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit

class DrinkByViewController: UIViewController {
    
    let cellID = "cell123"
    var searchKeys = [SearchKeys]()
    var searchKeys0 = [SearchKeys]()

    var filteredBottles = [SearchKeys]()
    var searchString: String = ""
    
//    var varietals: [Producers]?
    var searchWines: [AllLevel0]?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TableCell.self, forCellReuseIdentifier: cellID)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    let footerView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.layer.masksToBounds = true
        tv.text = "Total Bottles"
        tv.textAlignment = .center
        tv.backgroundColor = barTintColor
        tv.textColor = .white
        return tv
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.font = UIFont.systemFont(ofSize: 12)
        sb.searchTextField.addDoneButtonOnKeyboard()
        sb.autocapitalizationType = .none
        sb.placeholder = NSLocalizedString("drinkByTitle", comment: "")
        sb.subviews.first?.layer.cornerRadius = 10
        sb.subviews.first?.clipsToBounds = true
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupElements()
        setupNavigationBar()
        searchBar.resignFirstResponder()
                
//        varietals = allWine?.searchVarietals
        searchWines = allWine?.search
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeDrinkBySort),
                                               name: Notification.Name("changeDrinkBySort"),
                                               object: nil)

        
        searchWines = searchWines!.sorted(by: {
            ($0.label[0].available) > ($1.label[0].available)
        })
        
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)

        footerView.text = countBottles(bins: searchKeys)
    }
    
    @objc func handleReload(){
        searchWines = allWine?.search
        searchWines = searchWines!.sorted(by: {
            ($0.label[0].vvp.lowercased()) < ($1.label[0].vvp.lowercased())
        })
        
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        footerView.text = countBottles(bins: searchKeys)
        self.tableView.reloadData()
    }

    
    @objc func changeDrinkBySort(_ notification: Notification) {
        let drinkByMenuCode = (notification.userInfo?["drinkByMenuCode"])! as! String
        
        searchWines = allWine?.search
        searchWines = searchWines!.sorted(by: {
            ($0.label[0].available) > ($1.label[0].available)
        })
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        footerView.text = countBottles(bins: searchKeys)

        switch drinkByMenuCode {
        case "Linear":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].linear) > ($1.label[0].linear)
            })
        case "Bell":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].bell) > ($1.label[0].bell)
            })
        case "Early":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].early) > ($1.label[0].early)
            })
        case "Late":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].late) > ($1.label[0].late)
            })
        case "Fast":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].fast) > ($1.label[0].fast)
            })
        case "TwinPeak":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].twinPeak) > ($1.label[0].twinPeak)
            })
        case "Simple":
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].simple) > ($1.label[0].simple)
            })
        case "Missing":
            searchWines = searchWines!.filter{
                $0.label[0].drinkBy == ""
            }
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].producer) < ($1.label[0].producer)
            })
            searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
            footerView.text = countBottles(bins: searchKeys)
        default:
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].available) > ($1.label[0].available)
            })
        }
        
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)

        self.tableView.reloadData()

    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("drinkByTitle", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                                                title: "Log Out",
                                                style: UIBarButtonItem.Style.plain,
                                                target: self,
                                                action: #selector(handleLogOut))
    }
    
    func countBottles(bins: [SearchKeys])-> String{
        var totalBottles: Int = 0
        
        for (bin) in bins {
            for (bottles) in bin.storageBins! {
                totalBottles += bottles.bottleCount!
            }
        }
        
        let plural = totalBottles == 1 ? " Bottle" : " Bottles"
        
        return "\(totalBottles)" + plural
    }

    
    func configureUI() {
        view.backgroundColor = .green
        setupNavigationBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        showSearchBarButton(shouldShow: true)
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            
            let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            
            let sortIcon = UIImage(systemName: "arrow.up.arrow.down")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            
            let segmentedControl = UISegmentedControl(items: [
                searchIcon!,
                sortIcon!
            ])
            
            segmentedControl.addTarget(self, action: #selector(toggleDrinkByActions), for: .valueChanged)
            segmentedControl.frame = CGRect(x: 10, y: 0, width: 0, height: 30)
            segmentedControl.isMomentary = true
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                                                  title: "Log Out",
                                                  style: UIBarButtonItem.Style.plain,
                                                  target: self,
                                                  action: #selector(handleLogOut))
            
            let segmentBarItem = UIBarButtonItem(customView: segmentedControl)
            navigationItem.rightBarButtonItem = segmentBarItem
            
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func toggleDrinkByActions(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            handleShowSearchBar()
        } else {
            drinkByMenuLauncher.showDrinkByMenu()
        }
    }
    
    lazy var drinkByMenuLauncher: DrinkByMenuLauncher = {
        let launcher = DrinkByMenuLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func showControllerForDrinkByMenu(drinkByMenuItem: DrinkByMenuItem){
        let drinkByHelpController = DrinkByHelpController()
        navigationController?.pushViewController(drinkByHelpController, animated: true)
    }
    
    func search(shouldShow: Bool) {
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar!.translatesAutoresizingMaskIntoConstraints = false
        textFieldInsideSearchBar!.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        textFieldInsideSearchBar!.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textFieldInsideSearchBar!.topAnchor.constraint(equalTo: searchBarContainer.topAnchor, constant: 10).isActive = true
        
//        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: 24)
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBarContainer : nil
    }
    
}

extension DrinkByViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.searchTextField.text!
        searchBar.resignFirstResponder()
        print("searchBarSearchButtonClicked")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.searchTextField.text = ""
        filteredBottles = searchKeys
        footerView.text = countBottles(bins: filteredBottles)
        tableView.reloadData()
        searchBar.endEditing(true)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        if searchText.isEmpty {
            filteredBottles = searchKeys
        } else {
            filteredBottles = searchKeys.filter({( country: SearchKeys) -> Bool in
                
                return country.searckKey.localizedCaseInsensitiveContains(searchText)
                
            })
        }
        
        footerView.text = countBottles(bins: filteredBottles)

        tableView.reloadData()

    }
}

extension DrinkByViewController{
    func setupElements(){
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                   
        footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    }
}

extension DrinkByViewController: UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text!.isEmpty{
            return searchKeys.count
        } else {
            return filteredBottles.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var wineSelected = wineDetail()
        
        let bottle: SearchKeys
        
        if searchBar.text!.isEmpty{
            bottle = searchKeys[indexPath.row]
        } else {
            bottle = filteredBottles[indexPath.row]
        }
        
        wineSelected.vintage = bottle.vintage
        wineSelected.varietal = bottle.varietal
        wineSelected.drinkBy = bottle.drinkBy
        wineSelected.locale = bottle.locale
        wineSelected.producer = bottle.producer
        wineSelected.ava = bottle.appellation
        wineSelected.designation = bottle.designation
        wineSelected.region = bottle.region
        wineSelected.country = bottle.country
        wineSelected.type = bottle.type
        wineSelected.vineyard = bottle.vineyard
        wineSelected.storageBins = bottle.storageBins

        let wineDetailController = WineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
//        wineDetailController.myUpdater = (self as BottleCountDelegate)
        present(navController, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var totalBottles: Int = 0
        
        let colorOdd = tableStripeOdd
        let colorEven = tableStripeEven
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let bottle: SearchKeys
        
        
        if searchBar.text!.isEmpty{
            bottle = searchKeys[indexPath.row]
        } else {
            bottle = filteredBottles[indexPath.row]
        }
        
        for (bottles) in bottle.storageBins! {
            totalBottles += bottles.bottleCount!
        }
        
        var bottleCount = totalBottles == 1 ? " bottle" : " bottles"
        bottleCount = " (\(totalBottles) " + bottleCount + ")"
                
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 2;
        
        let line1 = bottle.vintage + " " + bottle.varietal + bottleCount
        let line2 = "  \(bottle.producer) - \(bottle.appellation)" +
                    "\n  " + NSLocalizedString("drinkByTitle", comment: "") + " \(bottle.drinkBy)"

        cell.textLabel?.text = line1
        cell.detailTextLabel?.text = line2
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        
        let selectedView = UIView()
        selectedView.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        cell.selectedBackgroundView = selectedView
        
//        cell.selectionStyle = .none

        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

