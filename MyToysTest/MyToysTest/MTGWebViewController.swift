//
//  MTGWebViewController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MTGWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    let firstLoad:String = "https://www.mytoys.de";
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var menuConfiguration:MTGMenuConfiguration?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ToysGroup";
        self.webView.delegate = self;
        self.loadMenu();
        self.loadHTML(firstLoad);
        self.navigationController!.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 255/255, green: 216/255, blue: 0, alpha: 1);
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor();
    }
    
     override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        
    }
    
    
    
    //MARK: Load Web & Menu
    func loadHTML(url:String) -> Void{
        self.activityIndicator.startAnimating();
        let url = NSURL (string: url);
        let requestObj = NSURLRequest(URL: url!);
        self.webView.loadRequest(requestObj);
    }
    
    func loadMenu () -> Void {
        //show a menu when load the data
        //to improve, we could show a button where update the menu again
        self.menuButton.hidden = true;
        let testMenuHelper:MTGMenuHelper = MTGMenuHelper();
        testMenuHelper.getMenu({ (menuConfiguration) in
            //
            if let menuConfigurationUnwrapped : MTGMenuConfiguration = menuConfiguration {
                self.menuButton.hidden = false;
                self.menuConfiguration = menuConfigurationUnwrapped;
                
            }
            
        }) { (error) in
            //
            //print a log in the screen with the error
        }
        
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueMenu" {
            
            if let menuTableViewControllerUnwrapped = segue.destinationViewController as? MTGMenuTableViewController {
                if let menuConfigurationUnwrapped:MTGMenuConfiguration = self.menuConfiguration {
                    menuTableViewControllerUnwrapped.setupController(menuConfigurationUnwrapped, title: "Menu", backButton: false, controllerWeb: self);
                }
                
            }
        }
        
    }
    
  
    
    //MARK: WebView Delegate
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating();
    }
    
}
