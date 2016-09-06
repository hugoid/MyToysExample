//
//  MTGMenuTableViewController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MTGMenuTableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var labelBackTableView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceMenu:MTGMenuConfiguration?;
    
    var controllerWeb:MTGWebViewController?;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 255/255, green: 216/255, blue: 0, alpha: 1);
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor();
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "iconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeController));
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
        
    }
    func closeController () -> Void {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
    
    func setupController (menu:MTGMenuConfiguration,title:String,backButton:Bool,controllerWeb:MTGWebViewController) -> Void {
        self.controllerWeb = controllerWeb;
        self.dataSourceMenu = menu;
        self.title = title;
        if !backButton {
            self.navigationItem.setHidesBackButton(true, animated: true);
        }
        else{
            self.navigationItem.setHidesBackButton(false, animated: true);
        }

        
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
            
            return menuItem.text;
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
            print("node");
            let menuConfiguration:MTGMenuConfiguration = MTGMenuConfiguration();
            menuConfiguration.listMenuItems = [menuItem.elements];
            let menuViewController:MTGMenuTableViewController =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("menuViewControllerID") as? MTGMenuTableViewController)!;
            menuViewController.setupController(menuConfiguration, title: menuItem.text!, backButton: true, controllerWeb: self.controllerWeb!);
            self.navigationController?.pushViewController(menuViewController, animated: true);
            
        }
        else{
            print("link");
            self.controllerWeb?.loadHTML(menuItem.url!);
            self.navigationController?.popToRootViewControllerAnimated(true);
        }
    }
    

    
    //MARK: Action Button
    
    @IBAction func pushBack(sender: AnyObject) {
    }
    
    @IBAction func pushCloseController(sender: AnyObject) {
    }
}
