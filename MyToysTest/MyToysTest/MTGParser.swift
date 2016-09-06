//
//  MTGParser.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation


public protocol MTGParser : class {
    
    func parseData( data : NSData? ,completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void )
    func parseJson( data : NSDictionary, completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void )
}


extension MTGParser {
    
    
    internal func fail( error : String, failed : ( error : NSError ) -> Void ){
        
        let error : NSError = NSError(domain: "MTGParser", code: 1, userInfo: ["error": error])
        failed(error: error)
    }
    
    //MARK: UEParser
    public func parseData( data : NSData?, completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void ) {
        
        
        //check data not null
        if let unwrappedData : NSData = data {
            
            do{
                
                
                let dataObject : AnyObject? = try NSJSONSerialization.JSONObjectWithData(unwrappedData , options:NSJSONReadingOptions.AllowFragments )
                if let dataObjectNotNil : AnyObject = dataObject {
                    
                   
                    if let dict : NSDictionary = dataObjectNotNil as? NSDictionary {
                        
                        self.parseJson( dict, completion: completion, failed: failed)
                    }
                    else{
                        
                        self.fail("Unknown object", failed: failed)
                    }
                }
                else{
                    
                    self.fail("Empty object", failed: failed)
                }
            }
            catch ( let error as NSError ){
                
                failed( error:  error )
            }
            catch{
                
                self.fail("Unknown error", failed: failed)
            }
            
        }
        else{
            
            self.fail("Empty data", failed: failed)
        }
    }
}