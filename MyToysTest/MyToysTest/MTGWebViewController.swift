//
//  MTGWebViewController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MTGWebViewController: UIViewController, UIWebViewDelegate {
    
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
        
        let testMenuHelper:MTGMenuHelper = MTGMenuHelper();
        testMenuHelper.getMenu({ (menuConfiguration) in
            //
            if let menuConfigurationUnwrapped : MTGMenuConfiguration = menuConfiguration {
                print("Menuconfiguration \(menuConfigurationUnwrapped)");
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
                //self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .Regular), forChildViewController: menuTableViewControllerUnwrapped);
                
                if let menuConfigurationUnwrapped:MTGMenuConfiguration = self.menuConfiguration {
                    menuTableViewControllerUnwrapped.setupController(menuConfigurationUnwrapped);
                }
                
            }
        }
        
    }
    
    //MARK: Action Button
    
    @IBAction func pushMenu(sender: AnyObject) {
        let menu:MTGMenuConfigurationController = MTGMenuConfigurationController();
        if let menuConfigurationUnwrapped:MTGMenuConfiguration = self.menuConfiguration {
            menu.setupController(menuConfigurationUnwrapped, title: "Menu", backButton: false,controllerWeb: self);
            self.navigationController?.pushViewController(menu, animated: true);
            
            
        }
        
    }
    
    //MARK: WebView Delegate
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating();
    }
    
}
