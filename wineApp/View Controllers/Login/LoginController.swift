//
//  ViewController.swift
//  audible
//
//  Created by Brian Voong on 9/1/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

var allWine: WineInventory?

protocol LoginControllerDelegate: class {
    func finishLoggingIn()
}

enum apiResults: String {
    case NoInternet
    case Success
    case Failed
}

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoginControllerDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    let loginCellId = "loginCellId"
    var dataLoaded = false
    
    var pages: [Page] = {
        let firstPage = Page(title: "Dude, where's my wine?", message: "You liked it, bought it, and brought it home.  What happened to it next?", imageName: "dwmw")

        let secondPage = Page(title: "You can search for it.", message: "Search by Producer, Varietal, Vineyard, AVA, or Designation", imageName: "dwmwSearch")

        let thirdPage = Page(title: "The More menu has other views", message: "Sort by Producer, Varietal, or by Location, great to use for physical inventory.", imageName: "dwmwMore")
        
        let fourthPage = Page(title: "Don't forget to check settings", message: "Don't use \"Barcode\", just turn it off!", imageName: "dwmwSettings")
        
        return [firstPage, secondPage, thirdPage, fourthPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = tableStripeEven
        pc.currentPageIndicatorTintColor = barTintColor
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(loginButtonColor, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()

    @objc func skip() {
        // we only need to lines to do this
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(loginButtonColor, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    @objc func nextPage() {
        //we are on the last page
        if pageControl.currentPage == pages.count {
            return
        }

        //second last page
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }

        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.getShowPages() {
        } else {
            pages.removeAll()
            nextButton.isHidden = true
            skipButton.isHidden = true
        }

        observeNotifications()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        pageControlBottomAnchor = pageControl.anchor(view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        
        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        //use autolayout instead
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerCells()
    }
    
    fileprivate func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(APILoaded), name: NSNotification.Name(rawValue: "APILoaded"), object: nil)
        
    }
    
    @objc func APILoaded(){
        dataLoaded = true
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            //back on regular pages
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 400
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // we're rendering our last login cell
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        
        return cell
    }
    
    func finishLoggingIn() {
                
        let userName = UserDefaults.standard.getUserName()
        let userPword = UserDefaults.standard.getUserPword()
        if (userName.isEmpty || userPword.isEmpty) {
            Alert.showLoginCredentialsAlert(on: self)
        } else {
            UserDefaults.standard.setIsLoggedIn(value: true)
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            guard let mainNavigationController = rootViewController as? MainTabBarController else { return }
            
            let spinnerText = NSLocalizedString("runAPI", comment: "")
            showSpinner(localizedText: spinnerText)
//            API.load()
            
            var timeLeft = 21
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//                print("timer fired!")
                timeLeft -= 1
                if timeLeft == 20 {
                    let results = API.load()
                    switch apiResults(rawValue: results)! {
                        case .Failed :
                            Alert.showAPIFailedsAlert(on: self)
                            timer.invalidate()
                            self.hideSpinner()
                        case .NoInternet:
                            Alert.noInternetAlert(on: self)
                            timer.invalidate()
                            self.hideSpinner()
                        case .Success:
                            break
                    }
                } else {
                    print(timeLeft)
                    if(self.dataLoaded == true){
                        timer.invalidate()
                        self.hideSpinner()
                        self.dismiss(animated: true, completion: nil)
                        mainNavigationController.viewControllers = [MainTabBarController()]
                    }
                    if(timeLeft == 0 && self.dataLoaded == false){
                        timer.invalidate()
                        self.hideSpinner()
                        Alert.showAPIFailedsAlert(on: self)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        //scroll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        
    }

}
