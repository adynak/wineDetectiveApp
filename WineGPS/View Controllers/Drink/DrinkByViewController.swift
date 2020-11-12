//
//  DrinkByViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class DrinkByViewController: UIViewController {
    
    let cellID = "cell123"
    var searchKeys = [SearchKeys]()
    
    var drinkByMenuCode = "Available"

    var filteredBottles = [SearchKeys]()
    var searchString: String = ""
    
    var searchWines: [AllLevel0]?
    var allSearchWines: [AllLevel0]?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TableCell.self, forCellReuseIdentifier: cellID)
        tv.delegate = self
        tv.dataSource = self
        tv.refreshControl = refreshControl
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
        tv.text = NSLocalizedString("totalBottles", comment: "plural : total bottles")
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
        sb.placeholder = NSLocalizedString("titleSearch", comment: "navigation title: search")
        sb.subviews.first?.layer.cornerRadius = 10
        sb.subviews.first?.clipsToBounds = true
        return sb
    }()
    
    let refreshControl: UIRefreshControl = {
        let spinnerText = NSLocalizedString("runAPI", comment: "textfield label: Getting Your Wines, text below animation while waiting for download")
        let rc = UIRefreshControl()
        rc.tintColor = barTintColor
        rc.attributedTitle = NSAttributedString(string: spinnerText, attributes: [
            NSAttributedString.Key.foregroundColor: barTintColor,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ])
        return rc
    }()

    @objc func removeRecentlyDrank(notification: NSNotification){
        let markAsDrank = DataServices.buildCellarTrackerList()
        if markAsDrank.count > 0 {
            filteredBottles = removeFilteredBottles(markAsDrank: markAsDrank, filteredBottles: filteredBottles)
            tableView.reloadData()
        }
    }
    
    func removeFilteredBottles(markAsDrank: [DrillLevel2] ,filteredBottles: [SearchKeys]) -> [SearchKeys]{
                
        for emptyBottle in markAsDrank {
            let findThisBarcode = emptyBottle.barcode
            for (index,someBottle) in self.filteredBottles.enumerated(){
                let storageBin = someBottle.storageBins
                
                if let foo = storageBin!.enumerated().first(where: {$0.element.barcode == findThisBarcode}) {
                   // do something with foo.offset and foo.element
                    if storageBin!.count > 1 {
                        self.filteredBottles[index].storageBins!.remove(at:foo.offset)
                    } else {
                        self.filteredBottles.remove(at: index)
                    }
                } else {
                   // item could not be found
                }
                
            }
            
        }
        
        return self.filteredBottles
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupElements()
        setupNavigationBar()
        searchBar.resignFirstResponder()
        
        refreshControl.addTarget(self, action: #selector(reloadSourceData(_:)), for: .valueChanged)
                
        searchWines = allWine?.drinkBy
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeRecentlyDrank), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeDrinkBySort),
                                               name: Notification.Name("changeDrinkBySort"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)

        let widgetVarietal = UserDefaults.standard.getWidgetVarietal()
        searchWines = allWine?.drinkBy
        allSearchWines = allWine?.drinkBy
        
        if !(widgetVarietal.isEmpty){
            let filteredWines = searchWines!.filter({
                return $0.label[0].varietal == widgetVarietal
            })
            searchBar.searchTextField.text = widgetVarietal
            searchWines = filteredWines
        } else {
            searchWines = allWine?.drinkBy
        }
        
        searchWines = buidSearchWinesFromDrinkByMenuCode(drinkByMenuCode: drinkByMenuCode)
        allSearchWines = searchWines

        tableView.reloadData()
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        filteredBottles = searchKeys
        footerView.text = DataServices.countBottles(bins: searchKeys)
    }
    
    @objc func handleReload(){
        let drinkBySort = DataServices.buildDrinkByBottlesArray(fields: fields, drinkByKey: "available")
        allWine?.drinkBy = drinkBySort
        searchWines = allWine?.drinkBy
        searchWines = buidSearchWinesFromDrinkByMenuCode(drinkByMenuCode: drinkByMenuCode)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("buttonLogOut", comment: "button text: Log Out"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleLogOut)
        )

        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        footerView.text = DataServices.countBottles(bins: searchKeys)
        self.tableView.reloadData()
    }
    
    @objc func handleLoadAllWine(){
        let widgetVarietal = ""
        UserDefaults.standard.setWidgetVarietal(value: "")
        searchBar.searchTextField.text = widgetVarietal
        handleReload()
        filteredBottles = searchKeys
    }

    @objc func changeDrinkBySort(_ notification: Notification) {
        let title = NSLocalizedString("titleDrinkBy", comment: "Navigation Bar menu title: Drink By.  This will display a list of wines sorted by when they should be consumed, from sooner to later.")
        let drinkByMenuCode = (notification.userInfo?["drinkByMenuCode"])! as! String
        
        let positionOfDrinkByMenuCode = drinkByMenuLauncher.drinkByMenuItems.firstIndex(where:{$0.drinkByMenuCode == drinkByMenuCode})
        
        let subtitle = drinkByMenuLauncher.drinkByMenuItems[positionOfDrinkByMenuCode!].drinkByNavTitle

        if drinkByMenuCode != "Cancel"{
            navigationItem.titleView = DataServices.setupTitleView(title: title, subTitle: subtitle)
        } else {
            return
        }
        
        if drinkByMenuCode == "Missing"{
            searchWines = DataServices.buildDrinkByBottlesArray(fields: fields, drinkByKey:"available")
        } else {
            searchWines = DataServices.buildDrinkByBottlesArray(fields: fields, drinkByKey: drinkByMenuCode.lowercased())
        }
        
        searchWines = buidSearchWinesFromDrinkByMenuCode(drinkByMenuCode: drinkByMenuCode)

//        switch drinkByMenuCode {
//        case "Linear":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].linear) > ($1.label[0].linear)
//            })
//        case "Bell":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].bell) > ($1.label[0].bell)
//            })
//        case "Early":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].early) > ($1.label[0].early)
//            })
//        case "Late":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].late) > ($1.label[0].late)
//            })
//        case "Fast":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].fast) > ($1.label[0].fast)
//            })
//        case "TwinPeak":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].twinPeak) > ($1.label[0].twinPeak)
//            })
//        case "Simple":
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].simple) > ($1.label[0].simple)
//            })
//        case "Missing":
//            searchWines = searchWines!.filter{
//                $0.label[0].drinkBy == ""
//            }
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].producer) < ($1.label[0].producer)
//            })
//        default:
//            searchWines = searchWines!.sorted(by: {
//                ($0.label[0].available) > ($1.label[0].available)
//            })
//        }
        
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        footerView.text = DataServices.countBottles(bins: searchKeys)

        self.tableView.reloadData()

    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setWidgetVarietal(value: "")

        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
    @objc private func reloadSourceData(_ sender: Any) {
        let results = API.load()
        
        searchWines = allWine?.drinkBy
        allSearchWines = allWine?.drinkBy
        
        let widgetVarietal = UserDefaults.standard.getWidgetVarietal()
        if !(widgetVarietal.isEmpty){
            let filteredWines = searchWines!.filter({
                return $0.label[0].varietal == widgetVarietal
            })
            searchBar.searchTextField.text = widgetVarietal
            searchWines = filteredWines
        } else {
            searchWines = allWine?.search
        }

        searchWines = buidSearchWinesFromDrinkByMenuCode(drinkByMenuCode: drinkByMenuCode)
        allSearchWines = searchWines

        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        filteredBottles = searchKeys
        footerView.text = DataServices.countBottles(bins: searchKeys)

        switch apiResults(rawValue: results)! {
            case .Failed :
                Alert.showAPIFailedsAlert(on: self)
                DataServices.endRefreshing(tv: tableView, rc: refreshControl)
            case .NoInternet:
                Alert.noInternetAlert(on: self)
                DataServices.endRefreshing(tv: tableView, rc: refreshControl)
            case .Success:
                break
        }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        }
        
    }
    
    func buidSearchWinesFromDrinkByMenuCode(drinkByMenuCode: String) -> [AllLevel0]{

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
        default:
            searchWines = searchWines!.sorted(by: {
                ($0.label[0].available) > ($1.label[0].available)
            })
        }
        return searchWines!
    }
    
    func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("titleDrinkBy", comment: "Navigation Bar menu title: Drink By.  This will display a list of wines sorted by when they should be consumed, from sooner to later.")
        let title = NSLocalizedString("titleDrinkBy", comment: "Navigation Bar menu title: Drink By.  This will display a list of wines sorted by when they should be consumed, from sooner to later.")
        
        let drinkByMenuCode = NSLocalizedString("drinkByNavTitleAvailable", comment: "drink by nav title Available DO NOT TRANSLATE")

        navigationItem.titleView = DataServices.setupTitleView(title: title, subTitle: drinkByMenuCode)
        
        let widgetVarietal = UserDefaults.standard.getWidgetVarietal()
        if widgetVarietal == "" {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("buttonLogOut", comment: "button text: Log Out"),
                style: UIBarButtonItem.Style.plain,
                target: self,
                action: #selector(handleLogOut)
            )
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("buttonAllWine", comment: "button text: All Wines, toggled with buttonLogOut"),
                style: UIBarButtonItem.Style.plain,
                target: self,
                action: #selector(handleLoadAllWine)
            )
        }
    }
    
    func configureUI() {
        view.backgroundColor = barTintColor
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
                                                  title: NSLocalizedString("buttonLogOut", comment: "button text: Log Out"),
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
        searchKeys = SearchKeys.BuildSearchKeys(wines: &allSearchWines!)
        filteredBottles = searchKeys
        footerView.text = DataServices.countBottles(bins: filteredBottles)
        tableView.reloadData()
        searchBar.endEditing(true)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
// smart quotes on the keyboard, not in the download, fool!
        let searchText = searchText.replacingOccurrences(of: "’", with: "\'", options: NSString.CompareOptions.literal, range: nil)
// match any word in any position by using an array.contains(where: ...
        let searchTextArray = searchText.split(separator: " ")

        if searchText.isEmpty {
            searchKeys = SearchKeys.BuildSearchKeys(wines: &allSearchWines!)
            filteredBottles = searchKeys
        } else {
            filteredBottles = searchKeys.filter({( text: SearchKeys) -> Bool in
// returns true when there is an exact match of needle in haystack
//                return text.searchKey.localizedCaseInsensitiveContains(searchText)
// returns true if needle is anywhere in the haystack
                return !searchTextArray.contains(where: { !text.searchKey.localizedCaseInsensitiveContains($0) })
            })
        }
        
        footerView.text = DataServices.countBottles(bins: filteredBottles)
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

        var wineSelected = WineDetail()
        var bottles: [DrillLevel2]? = []
        var detailTitle: String

        let bottle: SearchKeys
        
        if searchBar.text!.isEmpty{
            bottle = searchKeys[indexPath.row]
            detailTitle = NSLocalizedString("titleDrinkBy", comment: "navagation title: drink by")
        } else {
            bottle = filteredBottles[indexPath.row]
            detailTitle = searchBar.text!
        }
        
        let positionOf = DataServices.getPositionOf()

        if let wines = bottle.storageBins {
            for wine in wines {
                let iWine = wine.iwine
                var ava: String = ""
                var designation: String = ""
                var beginConsume: String = ""
                var endConsume: String = ""
                
                if let inventoryIndex = inventoryArray.firstIndex(where: { $0[0] == iWine }){
                       ava = inventoryArray[inventoryIndex][positionOf.ava]
                       designation = inventoryArray[inventoryIndex][positionOf.designation]
                       beginConsume = inventoryArray[inventoryIndex][positionOf.beginConsume]
                       endConsume = inventoryArray[inventoryIndex][positionOf.endConsume]
                   }
                bottles?.append(DrillLevel2(
                    producer: bottle.producer, varietal: bottle.varietal, vintage: bottle.vintage, iWine: wine.iwine, location: wine.binLocation, bin: wine.binName, barcode: wine.barcode, designation: designation, ava: ava, sortKey: "sortkey", beginConsume: beginConsume, endConsume: endConsume, viewName: "view", bottleCount: 1))
            }
        }
                
        wineSelected.bottles = bottles
        wineSelected.location = bottle.producer
        wineSelected.bin = bottle.varietal
        wineSelected.bottleCount = String(bottle.storageBins!.count)
        wineSelected.topLeft = bottle.producer
        wineSelected.topRight = bottle.varietal
        wineSelected.viewName = "drinkby"
        wineSelected.description = bottle.description

        let wineDetailController = DrillDownDetailViewController()
        wineDetailController.passedValue = wineSelected
        wineDetailController.title = detailTitle
        let navController = UINavigationController(rootViewController: wineDetailController)
        present(navController, animated: true, completion: nil)
//        don't clear the text from the searchBar
//        searchBarCancelButtonClicked(searchBar)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        var totalBottles: Int = 0
        var bottleCount: String = ""
        
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
        
//        var bottleCount = totalBottles == 1 ? NSLocalizedString("singularBottle", comment: "singular for the word bottle") : NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
        bottleCount = " (\(totalBottles))"
                
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 2;
        
//        let drinkByIndex = DataServices.findDrinkByIndex(iWine: bottle.storageBins![0].iwine!, drinkByKey: drinkByMenuCode)
        
        let line1 = bottle.vintage + " " + bottle.varietal + bottleCount
//        let line2 = "  \(bottle.producer)\n  \(NSLocalizedString("drinkByIndex", comment: "Drinkability Index, a magic index number used to sort wines")) \(drinkByIndex)"
        
        let line2 = "  \(bottle.description!)\n  \(NSLocalizedString("labelDrinkByWindow", comment: "textfield label: Drinking Window: 2020 - 2022")) \(bottle.drinkBy)"


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

