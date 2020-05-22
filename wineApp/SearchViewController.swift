//
//  ViewController.swift
//  SearchBar
//
//  Created by Stephen Dowless on 6/25/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit

var allWines: WineInventory?

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
    var countries = [Country]()
    var filteredCountries = [Country]()
    var searchString: String = ""
    
    var varietals: [Producers]?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserCell.self, forCellReuseIdentifier: cellID)
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
        tv.backgroundColor = UIColor(r: 61,  g: 91,  b: 151)
        tv.textColor = .white
        return tv
    }()
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.font = UIFont.systemFont(ofSize: 12)
        sb.searchTextField.addDoneButtonOnKeyboard()
        sb.autocapitalizationType = .none
        sb.placeholder = "Search"
        sb.subviews.first?.layer.cornerRadius = 10
        sb.subviews.first?.clipsToBounds = true


        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupElements()
//        setupNavigationBar()
        handleShowSearchBar()
        searchBar.resignFirstResponder()
        varietals = allWine?.varietals
        countries = Country.GetAllCountries(varietals: &(varietals)!)

        footerView.text = countBottles(bins: countries)
    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    func countBottles(bins: [Country])-> String{
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
        view.backgroundColor = .white
        setupNavigationBar()
        
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(r: 61,  g: 91,  b: 151) // background
        navigationController?.navigationBar.tintColor = .white
        
        showSearchBarButton(shouldShow: true)

    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = nil
//
//            navigationItem.rightBarButtonItem = UIBarButtonItem(
//                                                  barButtonSystemItem: .search,
//                                                  target: self,
//                                                  action:#selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 24)

        navigationItem.titleView = shouldShow ? searchBarContainer : nil

    }
    
    func setupNavigationBar() {
           let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
           searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 24)
           navigationItem.titleView = searchBarContainer
       }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.searchTextField.text!
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter({( country: Country) -> Bool in
                
                return country.searckKey.localizedCaseInsensitiveContains(searchText)
                
            })
        }
        
        footerView.text = countBottles(bins: filteredCountries)

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
            return countries.count
        } else {
            return filteredCountries.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var wineSelected = wineDetail()
        
        let bottle: Country
        
        if searchBar.text!.isEmpty{
            bottle = countries[indexPath.row]
        } else {
            bottle = filteredCountries[indexPath.row]
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

        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
//        wineDetailController.myUpdater = (self as BottleCountDelegate)
        present(navController, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var totalBottles: Int = 0
        
        let colorOdd = UIColor(r:184, g:206, b:249)
        let colorEven = UIColor(r:202, g:227, b:255)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let bottle: Country
        
        
        if searchBar.text!.isEmpty{
            bottle = countries[indexPath.row]
        } else {
            bottle = filteredCountries[indexPath.row]
        }
        
        for (bottles) in bottle.storageBins! {
            totalBottles += bottles.bottleCount!
        }
        
        var bottleCount = totalBottles == 1 ? " bottle" : " bottles"
        bottleCount = " (\(totalBottles) " + bottleCount + ")"
                
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 2;
        
        let line1 = bottle.vintage + " " + bottle.varietal + bottleCount
        let line2 = "  " + bottle.producer + "\n  " + bottle.appellation

        cell.textLabel?.text = line1
        cell.detailTextLabel?.text = line2
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven

        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
