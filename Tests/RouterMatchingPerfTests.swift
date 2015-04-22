//
//  RouterMatchingPerfTests.swift
//  Router
//
//  Created by Martino Buffolino on 4/21/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit
import XCTest

class RouterMatchingPerfTests: XCTestCase {

    var myRouter: Router?
    let numOfRoutes = 1000
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myRouter = Router()
        
        for i in 0 ..< numOfRoutes {
            myRouter!.bind("/\(i)/a/:a/b/:b/c/:c/d/:d/e/:e/f/:f") { (req) -> Void in
                XCTAssert(req.param("a")! == "apple", "Invalid req param")
                XCTAssert(req.param("b")! == "bar" , "Invalid req param")
                XCTAssert(req.param("c")! == "cat" , "Invalid req param")
                XCTAssert(req.param("d")! == "dog" , "Invalid req param")
                XCTAssert(req.param("e")! == "elephant" , "Invalid req param")
                XCTAssert(req.param("f")! == "asdf1234" , "Invalid req param")
            }
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        myRouter = nil
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            myRouter!.match(NSURL(string: "/\(numOfRoutes - 1)/a/apple/b/bar/c/cat/d/dog/e/elephant/f/asdf1234")!)
        }
    }

}
