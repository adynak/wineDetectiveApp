//
//  SearchBarContainerView.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class SearchBarContainerView: UIView {
    
    let searchBar: UISearchBar

    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

        addSubview(searchBar)
    }

    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}

class SearchViewController: UIViewController {
    
    let cellID = "cell123"
    var searchKeys = [SearchKeys]()

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
        sb.placeholder = NSLocalizedString("titleSearch", comment: "navigation title: search")
        sb.subviews.first?.layer.cornerRadius = 10
        sb.subviews.first?.clipsToBounds = true
        return sb
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeRecentlyDrank), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

        tellCellarTracker()

        configureUI()
        setupElements()
        setupNavigationBar()
        searchBar.resignFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)
        
        let widgetVarietal = UserDefaults.standard.getWidgetVarietal()
        searchWines = allWine?.search
        allSearchWines = allWine?.search
        allSearchWines = allSearchWines!.sorted(by: {
            ($0.label[0].vvp.lowercased()) < ($1.label[0].vvp.lowercased())
        })

        if !(widgetVarietal.isEmpty){
            let filteredWines = searchWines!.filter({
                return $0.label[0].varietal == widgetVarietal
            })
            searchBar.searchTextField.text = widgetVarietal
            searchWines = filteredWines
        } else {
            searchWines = allWine?.search
        }

        searchWines = searchWines!.sorted(by: {
            ($0.label[0].vvp.lowercased()) < ($1.label[0].vvp.lowercased())
        })
        tableView.reloadData()
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        filteredBottles = searchKeys
        footerView.text = DataServices.countBottles(bins: searchKeys)
    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    @objc func handleReload(){

        searchWines = allWine?.search
        searchWines = searchWines!.sorted(by: {
            ($0.label[0].vvp.lowercased()) < ($1.label[0].vvp.lowercased())
        })
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("buttonLogOut", comment: "button text: Log Out"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleLogOut)
        )
        searchKeys = SearchKeys.BuildSearchKeys(wines: &searchWines!)
        footerView.text = DataServices.countBottles(bins: searchKeys)
        tableView.reloadData()
    }
    
    @objc func handleLoadAllWine(){
        let widgetVarietal = ""
        UserDefaults.standard.setWidgetVarietal(value: "")
        searchBar.searchTextField.text = widgetVarietal
        handleReload()
            filteredBottles = searchKeys
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setWidgetVarietal(value: "")

        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
    func tellCellarTracker(){
        var markAsDrank = [DrillLevel2]()

        markAsDrank = DataServices.buildCellarTrackerList()
        if markAsDrank.count > 0 {
            
            let syncController = SyncViewController()
            syncController.markAsDrank = markAsDrank
            let navController = UINavigationController(rootViewController: syncController)
            present(navController, animated: true, completion: nil)
        }
            
    }
    
    func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("titleSearch", comment: "navigation title: search")
        
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
        view.tintColor = .black
        setupNavigationBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        showSearchBarButton(shouldShow: true)
    }
            
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("buttonLogOut", comment: "button text: Log Out"),
                style: UIBarButtonItem.Style.plain,
                target: self,
                action: #selector(handleLogOut)
            )
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .search,
                target: self,
                action:#selector(handleShowSearchBar)
            )
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
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

extension SearchViewController: UISearchBarDelegate {
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
        var searchTextArray = searchText.components(separatedBy: " ")
        if searchTextArray.last == "" {
            searchTextArray.removeLast()
        }

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

extension SearchViewController{
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text!.isEmpty{
            return searchKeys.count
        } else {
            return filteredBottles.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var wineSelected = WineDetail()
        var bottles: [DrillLevel2]? = []
        var detailTitle: String
        
        let bottle: SearchKeys
        
        if searchBar.text!.isEmpty{
            bottle = searchKeys[indexPath.row]
            detailTitle = NSLocalizedString("titleSearch", comment: "navigation title: search")
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
//                var description: String = ""
                
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
        wineSelected.viewName = "search"
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
        
        bottleCount = " (\(totalBottles))"
                
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 1;
        
        let line1 = bottle.vintage + " " + bottle.varietal + bottleCount
        let line2 = bottle.description

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

