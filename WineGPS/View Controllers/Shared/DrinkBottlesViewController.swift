////
////  DrinkBottlesViewController.swift
////  WineGPS
////
////  Created by adynak on 1/1/20.
////  Copyright © 2020 Al Dynak. All rights reserved.
////
//
//import UIKit
//import WebKit
//
//class DrinkBottlesViewController: UIViewController , WKNavigationDelegate{
//    
//    var webView : WKWebView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let mainTabBarController = MainTabBarController()
//        mainTabBarController.tabBar.isHidden = true
//        navigationItem.title = NSLocalizedString("removeBottles", comment: "navigation item: remove bottles from inventory")
//
//        setUpWebView()
//    }
//    
//    func setUpWebView(){
//        // loading URL :
//        let aURLString = "https://www.apple.com"
////        let aURLString = "https://www.cellartracker.com/barcode.asp?iWine=3639333"
//        //https://www.cellartracker.com/barcode.asp?iWine=3639333&iInventory=0128729917
//        let url  = URL(string: aURLString)
//        let request = URLRequest(url: url!)
//        let webViewFrame = CGRect(x: 0, y: 25, width: 414, height: 786)
//        
//        webView = WKWebView(frame: webViewFrame)
////        webView.frame = CGRect(x: 0, y: 25, width: 414, height: 786)
//
//        /* A class conforming to the WKNavigationDelegate protocol can provide
//         methods for tracking progress for main frame navigations and for deciding
//         policy for main frame and subframe navigations.
//         */
//        webView.navigationDelegate = self
//        //Load the request
//        webView.load(request)
//        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
//
//        //add webView as sub view of parent view
//        view.addSubview(webView)
//    }
//       
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            print(Float(webView.estimatedProgress))
//        }
//    }
//
//    //handle error
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    //web view start loading
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        let localizedText = NSLocalizedString("loadingWebPage", comment: "textfield label: Loading Web Page, text below animation while page loads")
//        showSpinner(localizedText: localizedText)
//        Alert.debugPrint(debugMessage: "start loading webView")
//    }
//    
//    //web view finish loading
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        hideSpinner()
//        Alert.debugPrint(debugMessage: "finish loading webView")
//    }
//    
//}
//
//extension WKWebView {
//    
//    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
//       if(error.code == NSURLErrorNotConnectedToInternet){
//        Alert.debugPrint(debugMessage: "WTF")
//       }
//    }
//
//}
