//
//  MTGMenuTableViewController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MTGMenuTableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    @IBOutlet weak var labelBackTableView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceMenu:MTGMenuConfiguration?;
    
    var controllerWeb:MTGWebViewController?;
    
    var backHidden:Bool = false;
    var labelTitle:String = "";
    var labelBackTitle:String = "";
    
    @IBOutlet weak var labelBackItemNavigation: UILabel!
    @IBOutlet weak var labelTitleItemNavigation: UILabel!
    
    @IBOutlet weak var viewBack: UIControl!
    var isPresenting: Bool!
    let animationDuration = 0.3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !backHidden {
            self.viewBack.hidden = true;
        }
        else{
            self.viewBack.hidden = false;
        }
    
        self.labelBackItemNavigation.text = labelBackTitle;
        self.labelTitleItemNavigation.text = labelTitle;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
        
    }
    
    func setupController (menu:MTGMenuConfiguration,title:String,titleBack:String,backButton:Bool,controllerWeb:MTGWebViewController) -> Void {
        self.controllerWeb = controllerWeb;
        self.dataSourceMenu = menu;
        
        self.labelTitle = title;
        self.labelBackTitle = titleBack;
        self.backHidden = backButton;
        
        
        
        
    }
    
    
    
    func closeController () -> Void {
        self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: {
            //
        });
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let dataSourceMenuUnwrapped = self.dataSourceMenu {
            let numberSection:Int = (dataSourceMenuUnwrapped.listMenuItems.count);
            
            return numberSection;
        }
        else{
            return 0;
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let dataSourceMenuUnwrapped = self.dataSourceMenu {
            
            let menuItemList:[MTGMenuItem] = (dataSourceMenuUnwrapped.listMenuItems[section]);
            
            
            let menuItem : MTGMenuItem = menuItemList[0];
            //check if is section or more children
            
            if menuItem.elementType == "section" {
                return menuItem.text;
            }
            else{
                return "";
            }
        
        }
        else{
            return "";
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let dataSourceMenuUnwrapped = self.dataSourceMenu {
            let menuItemList:[MTGMenuItem] = (dataSourceMenuUnwrapped.listMenuItems[section]);
            
            let menuItem : MTGMenuItem = menuItemList[0];
            //check if is section or more children
            var numberRows : Int = 0;
            if menuItem.elementType == "section" {
                numberRows = menuItemList[0].elements.count;
            }
            else{
                numberRows = menuItemList.count;
            }
            
            return numberRows;
        }
        else {
            return 0;
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[indexPath.section])!;
        let menuItem:MTGMenuItem;
        
        let menuItemCheckSection : MTGMenuItem = menuItemList[0];
        //check if is section or more children
        
        if menuItemCheckSection.elementType == "section" {
            menuItem = menuItemList[0].elements[indexPath.row];
        }
        else{
            menuItem = menuItemList[indexPath.row];
        }
        
        
        cell.textLabel?.text = menuItem.text;
        
        if menuItem.elementType == "node" {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[indexPath.section])!;
        let menuItem:MTGMenuItem ;
        
        let menuItemCheckSection : MTGMenuItem = menuItemList[0];
        //check if is section or more children
        
        if menuItemCheckSection.elementType == "section" {
            menuItem = menuItemList[0].elements[indexPath.row];
        }
        else{
            menuItem = menuItemList[indexPath.row];
        }
        
        if menuItem.elementType == "node" {
            
            let menuConfiguration:MTGMenuConfiguration = MTGMenuConfiguration();
            menuConfiguration.listMenuItems = [menuItem.elements];
            let menuViewController:MTGMenuTableViewController =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("menuViewControllerID") as? MTGMenuTableViewController)!;
            menuViewController.setupController(menuConfiguration, title: menuItem.text!,titleBack:self.labelTitleItemNavigation.text!, backButton: true, controllerWeb: self.controllerWeb!);
            menuViewController.transitioningDelegate = self
            menuViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(menuViewController, animated: true, completion: {
                //
            });
            
        }
        else{
           
            self.controllerWeb?.loadHTML(menuItem.url!);
            self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: {
                //
            });
        }
    }
    
    //MARK: Action Button
    
    
    @IBAction func pushCloseMenu(sender: AnyObject) {
        self.closeController();
    }
    
    @IBAction func pushBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            //
        });
    }
    
    //MARK: Animation Push View Controller
    //It would be better create a MenuTableViewControllerPushAnimation with this method, and this class extend the class
    // to reduce the size for this class
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false;
        return self
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 5
        
    }
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self;
    }
    
    
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView();
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        toViewController!.view.frame = fromViewController!.view.frame
        if(self.isPresenting == true) {
            toViewController!.view.alpha = 0;
            //toViewController!.view.transform = CGAffineTransformMakeScale(0, 0);
            toViewController!.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, self.view.frame.origin.y)
            
            UIView.animateWithDuration(animationDuration, animations: {
                //
                toViewController!.view.alpha = 1;
                //toViewController!.view.transform = CGAffineTransformMakeScale(1, 1);
                toViewController!.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.origin.y)
                containerView!.addSubview(toViewController!.view)
                }, completion: { (completed) in
                    transitionContext.completeTransition(completed)
            })
            
            
            
        } else {
            
            UIView.animateWithDuration(animationDuration, animations: {
                //
                
                fromViewController!.view.alpha = 0;
                fromViewController!.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, self.view.frame.origin.y)                }, completion: { (completed) in
                    fromViewController?.view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
            })
            
            
        }
    }
    
    
}
