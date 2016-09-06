//
//  MTGMenuConfiguration.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation


//data source to tableView

public class MTGMenuConfiguration {
    
    //if receive more values in the json we can create in this class
    
    
    public var listMenuItems :  [[MTGMenuItem]]
    
    
    public init(){
        self.listMenuItems = [[MTGMenuItem]]()
    }
    
    
}