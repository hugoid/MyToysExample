//
//  MTGParser.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation



/**
 Protocolo que representa lo que deben implementar los parseadores del framework (se debería implementar solo parseJson, porque parseData esta implementado en "extension UEParser")
 */
public protocol MTGParser : class {
    
    func parseData( data : NSData? ,completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void )
    func parseJson( data : NSDictionary, completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void )
}

/**
 Implementación por defecto del parseador
 */
extension MTGParser {
    
    /**
     Gestiona el los errores
     - parameter error: el error que se ha producido
     - parameter failed: bloque de error
     */
    internal func fail( error : String, failed : ( error : NSError ) -> Void ){
        
        let error : NSError = NSError(domain: "MTGParser", code: 1, userInfo: ["error": error])
        failed(error: error)
    }
    
    //MARK: UEParser
    
    /**
     Gestiona los errores comunes en los datos recividos y los envia a parsear a traves de parseJson
     - parameter data: datos recividos
     - parameter whiteList: lista blanca de objetos que se pueden parsear
     - parameter options: lista de opciones para el parseo
     - parameter completion: bloque de que el parseo se ha realizado correctamente
     - parameter failed: bloque de error
     */
    public func parseData( data : NSData?, completion : ( result : AnyObject? ) -> Void, failed : ( error : NSError ) -> Void ) {
        
        
        //Comprobamos que los datos no sean nulos
        if let unwrappedData : NSData = data {
            
            do{
                
                //Convertimos el json en un objeto y comprobamos que no sea nulo
                let dataObject : AnyObject? = try NSJSONSerialization.JSONObjectWithData(unwrappedData , options:NSJSONReadingOptions.AllowFragments )
                if let dataObjectNotNil : AnyObject = dataObject {
                    
                    //Comprobampos que el objeto sea un diccionario y lo parseamos
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