//
//  RouterTests.swift
//  RouterTests
//
//  Created by Martino Buffolino on 4/20/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit
import XCTest

class RouterTests: XCTestCase {
    
    var myRouter: Router?
    let numOfRoutes = 10000
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myRouter = Router()
        
        for i in 0 ..< numOfRoutes {
            myRouter!.bind("/test/route/\(i)") { (req) -> Void in
                println("matched \(req.route.route)")
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
            myRouter!.match(NSURL(string: "/test/route/\(numOfRoutes - 1)")!)
        }
    }
    
}
