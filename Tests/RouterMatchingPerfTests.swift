////////////////////////////////////////////////////////////////////////////
// Copyright 2015 Viacom Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////

import UIKit
import XCTest
@testable import Router

class RouterMatchingPerfTests: XCTestCase {

    var myRouter: Router!
    let numOfRoutes = 1000
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myRouter = Router()
        
        for i in 0 ..< numOfRoutes {
            myRouter.bind("/\(i)/a/:a/b/:b/c/:c/d/:d/e/:e/f/:f") { (req) -> Void in
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
        self.measure() {
            // Put the code you want to measure the time of here.
            _ = self.myRouter.match(URL(string: "/\(self.numOfRoutes - 1)/a/apple/b/bar/c/cat/d/dog/e/elephant/f/asdf1234")!)
        }
    }

}
