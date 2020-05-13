//
//  SearchViewController.swift
//  wineApp
//
//  Created by adynak on 5/11/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let cellID = "cell123"
    let countries = Country.GetAllCountries()
    var filteredCountries = [Country]()
    
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
//        tv.contentInset=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        tv.backgroundColor = UIColor(r: 61,  g: 91,  b: 151)
        tv.textColor = .white
        return tv
    }()
        
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.sizeToFit()
        sb.autocapitalizationType = .none
        sb.searchBarStyle = .prominent
        sb.backgroundColor = .lightGray
        return sb
    }()

    var totalBottles: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupElements()
        
        for (bottleCount) in countries {
            totalBottles += bottleCount.storageBins.bottleCount
        }
        
        footerView.text = countBottles(bottles: countries)
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

    func countBottles(bottles: [Country])-> String{
        var totalBottles: Int = 0
        
        for (bottleCount) in bottles {
            totalBottles += bottleCount.storageBins.bottleCount
        }
        
        let plural = totalBottles == 1 ? " Bottle" : " Bottles"
        
        return "\(totalBottles)" + plural
    }

    
    func configureUI() {
        view.backgroundColor = .white
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        
//        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255,
//                                                                   green: 120/255,
//                                                                   blue: 250/255,
//                                                                   alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        
        let cancelButton = UIBarButtonItem(title: "Log Out",
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(handleLogOut))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Search"
        
        searchBar.heightAnchor.constraint(equalToConstant: 24).isActive = true

        
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = .white
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green,
//        NSAttributedString.Key.backgroundColor: UIColor.blue]

        
//        handleShowSearchBar()
        showSearchBarButton(shouldShow: true)
        
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
        
        searchBar.searchTextField.text = ""
        footerView.text = countBottles(bottles: countries)

        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredCountries = countries.filter({( country: Country) -> Bool in
        
            return  country.searckKey.lowercased().contains(searchText.lowercased())
            
        })
        if searchText == "" {
            filteredCountries = countries
        }
        
        footerView.text = countBottles(bottles: filteredCountries)

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
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let colorOdd = UIColor(r:184, g:206, b:249)
        let colorEven = UIColor(r:202, g:227, b:255)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let bottle: Country
        
        if searchBar.text!.isEmpty{
            bottle = countries[indexPath.row]
        } else {
            bottle = filteredCountries[indexPath.row]
        }
                
        cell.textLabel?.numberOfLines = 0
        
        let line1 = bottle.vintage + " " +
                    bottle.producer + " " +
                    bottle.varietal
        let line2 = "  " + bottle.appellation

        cell.textLabel?.text = line1
        cell.detailTextLabel?.text = line2
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven

        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
