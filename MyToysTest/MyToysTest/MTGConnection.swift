//
//  MTGConnection.swift
//  MyToysTest
//
//  Created by Hugo Izquierdo on 9/5/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MTGConnection: NSObject {
    
    
    override init (){
        
    }
    
    
    typealias successRequest = (data:NSData) -> ();
    typealias failRequest = (error:NSError) -> ();
    
    func loginMyToysGroup(success:successRequest,fail:failRequest){
        
        let urlRequest: String = Constants.loginConnection.url;
        
        
        Alamofire.request(.GET, urlRequest, parameters: nil, encoding: .URL,headers:[Constants.loginConnection.header:Constants.loginConnection.apiKey])
            .responseJSON {response in
                guard response.result.error == nil else {
                    fail(error: response.result.error!);
                    return
                }
                if let value: NSData = response.data {
                    success(data: value);
                }
        }
        
        
    }
    
    
}



