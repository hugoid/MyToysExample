//
//  MTGMenuHelper.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation


public class MTGMenuHelper: NSObject {

    typealias menuHelperSuccess = (menuConfiguration: MTGMenuConfiguration) -> Void
    typealias menuHelperFailure = (error: NSError?) -> Void
    
    
    func getMenu(successMenu:menuHelperSuccess,failMenu:menuHelperFailure){
        
        
        let testConnection:MTGConnection = MTGConnection();
        testConnection.loginMyToysGroup({ (data) in
            //
            
            
            let parserMenu:MTGMenuParser = MTGMenuParser ();
            parserMenu.parseData(data, completion: { (result) in
                //
                
                if let menuConfigurationUnwrapped : MTGMenuConfiguration = result as? MTGMenuConfiguration {
                    successMenu(menuConfiguration: menuConfigurationUnwrapped);
                }
                
                }, failed: { (error) in
                    //
                    failMenu(error: error);
            })
            
        }) { (error) in
            failMenu(error: error);
        }
        
    }

}