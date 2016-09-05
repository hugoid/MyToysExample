//
//  MyController.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import UIKit

class MyController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var labelBackTableView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceMenu:MTGMenuConfiguration?;
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
    }
    
    func setupController (menu:MTGMenuConfiguration) -> Void {
        self.dataSourceMenu = menu;
        let xx = self.dataSourceMenu;
        print("Mi datasource  \(self.dataSourceMenu.debugDescription)");
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberSection:Int = (self.dataSourceMenu?.listMenuItems.count)!;
        return numberSection;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[section])!;
        let menuItem : MTGMenuItem = menuItemList[0];
        return menuItem.text;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let xx = self.dataSourceMenu;
        let menuItem:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[section])!;
        let numberRows : Int = menuItem[0].elements.count;
        print("\(menuItem)");
        return numberRows;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[indexPath.section])!;
        let menuItem:MTGMenuItem = menuItemList[0].elements[indexPath.row];
        cell.textLabel?.text = menuItem.text;
        
        if menuItem.elementType == "node" {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let menuItemList:[MTGMenuItem] = (self.dataSourceMenu?.listMenuItems[indexPath.section])!;
        let menuItem:MTGMenuItem = menuItemList[0].elements[indexPath.row];
        
        if menuItem.elementType == "node" {
            print("node");
            
            
            
            /*let secondMenu:MTGMenuTableViewController = MTGMenuTableViewController(nibName: "MTGMenuTableViewController", bundle: nil);
             secondMenu.setupController(self.dataSourceMenu!);
             self.navigationController?.pushViewController(secondMenu, animated: true);*/
            
            let secondMenu:MyController = MyController();
            secondMenu.setupController(self.dataSourceMenu!);
            self.navigationController?.pushViewController(secondMenu, animated: true);
            
        }
        else{
            print("link");
        }
    }
    
    
    
    //MARK: Action Button
    
    @IBAction func pushBack(sender: AnyObject) {
    }
    
    @IBAction func pushCloseController(sender: AnyObject) {
    }

}
