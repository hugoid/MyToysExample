//
//  MyToysTestTests.swift
//  MyToysTestTests
//
//  Created by Hugo Izquierdo on 9/6/16.
//  Copyright © 2016 MyToys. All rights reserved.
//

import XCTest
@testable import MyToysTest

class MyToysTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
   
    //test if the element navigationEntries is not null
    
    func testConnection () {
        let networking = Networking()
        
        let url:String = "https://mytoysiostestcase1.herokuapp.com/api/navigation";
        
        let getData : XCTestExpectation? = expectationWithDescription("getData")
        networking.getHTTPDataFromURL(NSURL(string: url), success: { (data, response, error) in
            getData?.fulfill()
            
            if let unwrpdData = data as NSData! {
                
                let jsonData: NSDictionary? = try! NSJSONSerialization.JSONObjectWithData(unwrpdData, options:.AllowFragments) as! NSDictionary
                
                if jsonData != nil {
                    XCTAssertTrue(true, "receive data");
                }
                else{
                    XCTFail("data receive null");
                }
                
                
            }
            }, failure: { (data, response, error) in
                XCTAssertNotNil(error, "Error: \(error?.localizedDescription)")
        })
        
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            XCTAssertNil(error, "Timeout error: \(error) to get \(url)")
        }
    }
    
    //Test parser and model with a local file
    //if this test doesn't work it won't work with online file
    func testParserLocal () {
        
        var data: NSData?
        let path = NSBundle.mainBundle().pathForResource("testData", ofType: "json")
        if let unwrpdPath = path {
            data = NSData(contentsOfFile: unwrpdPath)
            let parserMenu:MTGMenuParser = MTGMenuParser ();
            parserMenu.parseData(data, completion: { (result) in
                //
                if let menuConfigurationUnwrapped : MTGMenuConfiguration = result as? MTGMenuConfiguration {
                    
                    //test if the first element is section with text Sortiment
                    //we could test more attributes about children(node or link for example)
                    let itemSectionlist:[MTGMenuItem] = menuConfigurationUnwrapped.listMenuItems[0];
                    let itemSection:MTGMenuItem = itemSectionlist[0];
                    XCTAssertEqual(itemSection.text, "Sortiment");
                    XCTAssertEqual(itemSection.elementType, "section");
                    //test more, children, etc
                    
                }
                
                }, failed: { (error) in
                    //
                    XCTFail("fail parser");
                    
            })
            
           
        }
        
    }
    
    
    
    
}
