//
//  MTGMenuConfigurationController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MTGMenuConfigurationController: UIViewController  ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var labelBackTableView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceMenu:MTGMenuConfiguration?;
    
    var controllerWeb:MTGWebViewController?;
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(closeController))
        
        
    }
    func closeController () -> Void {
        print("tape");
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
        let numberSection:Int = (self.dataSourceMenu?.listMenuItems.count)!;
        
        return numberSection;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[section])!;
        
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[section])!;
        
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
            
            
            
            let secondMenu:MTGMenuConfigurationController = MTGMenuConfigurationController();
            let menuConfiguration:MTGMenuConfiguration = MTGMenuConfiguration();
            menuConfiguration.listMenuItems = [menuItem.elements];
            secondMenu.setupController(menuConfiguration, title: menuItem.text!, backButton: true, controllerWeb: self.controllerWeb!);
            self.navigationController?.pushViewController(secondMenu, animated: true);
            
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
