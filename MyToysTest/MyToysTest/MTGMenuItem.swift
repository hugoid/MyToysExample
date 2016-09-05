//
//  MTGMenuItem.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation


public class MTGMenuItem {
    
    //MARK: public var
    
    /**
     Text label
     */
    public var text : String?
    /**
     Tipo de elemento
     */
    public var elementType : String?
    public var url: String?
    /**
     Elementos
     */
    public var elements : [MTGMenuItem]
    
    public var stringIdentifier : String?
    
    public var idsParents: [String]?
    
    
    
    
    public init(){
        self.elements = [MTGMenuItem]()
    }
    
    
    public func createItem() -> MTGMenuItem{
        let item : MTGMenuItem = MTGMenuItem()
        item.text = self.text
        item.elementType = self.elementType
        item.elements.appendContentsOf( self.elements )
        item.stringIdentifier = self.stringIdentifier
        item.idsParents = self.idsParents
        item.url = self.url;
        return  item
    }
    
}