//
//  MTGMenuParser.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation


public class MTGMenuParser:MTGParser  {
    
   
    
    public init() { }
    public func parseJson(data: NSDictionary, completion: (result: AnyObject?) -> Void, failed: (error: NSError) -> Void) {
        
        let configurationItem : MTGMenuConfiguration = MTGMenuConfiguration()
        
        
        //get data from navigationEntries

        let navigationElements:NSMutableDictionary = ["children":data["navigationEntries"]!];
        if let elements : NSArray = navigationElements["children"] as? NSArray {
            
            var i : Int = 0
            var position : Int = 0
            while ( i < elements.count ){
                
                if let element : NSDictionary = elements.objectAtIndex(i) as? NSDictionary {
                    
                    let menuItem : MTGMenuItem = self.parseMenuItem(element, idsParents: nil)
                    
                    configurationItem.listMenuItems.append([menuItem])
                    position += 1
                    
                    
                    
                }
                i += 1
            }
        }
        completion(result: configurationItem)
    }
    
    
    
    public func parseMenuItem( item: NSDictionary, idsParents: [String]? ) -> MTGMenuItem {
        
        let menuItem : MTGMenuItem = MTGMenuItem()
        
        
        
        if let text : String = item.objectForKey("label") as? String {
            
            menuItem.text = text
        }
        if let elementType : String = item.objectForKey("type") as? String {
            
            menuItem.elementType = elementType
        }
        if let urlLink : String = item.objectForKey("url") as? String {
            
            menuItem.url = urlLink
        }
        if let elements : NSArray = item.objectForKey("children") as? NSArray {
            
            let idsParentsFinal: [String]?
            if let idItem: String = menuItem.stringIdentifier {
                
                if var idsParentsUnwrapped: [String] = idsParents {
                    
                    idsParentsUnwrapped.append(idItem)
                    idsParentsFinal = idsParentsUnwrapped
                }
                else{
                    
                    idsParentsFinal = [idItem]
                }
            }
            else{
                
                idsParentsFinal = idsParents
            }
            menuItem.elements = self.parserElements(elements, idsParents: idsParentsFinal)
        }
        
        
        return menuItem
    }
    
    
    
    
    
    
    
    /**
     parser menu elements
     - parameter elements: array menu elements
     - returns: array with menuitem as a model
     */
    public func parserElements ( elements : NSArray, idsParents: [String]? ) -> [MTGMenuItem] {
        
        var list :  [MTGMenuItem] = [MTGMenuItem]()
        
        for element : AnyObject in elements {
            
            if let elementDict : NSDictionary = element as? NSDictionary {
                
                //Parser a element
                let item : MTGMenuItem = self.parseMenuItem(elementDict, idsParents: idsParents)
                
                list.append(item)
                
            }
        }
        
        return list
    }
}