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
import Quick
import Nimble

class ExampleSpec: QuickSpec {
    
    override func spec() {
        
        describe("plist config") {
            
            it("deeplink scheme is in plist") {
                var plist: NSDictionary?
                if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                    plist = NSDictionary(contentsOfFile: path)
                    
                    let urlTypes = plist!["CFBundleURLTypes"] as! NSArray
                    let firstItem = urlTypes[0] as! NSDictionary
                    
                    let urlName = firstItem["CFBundleURLName"] as! String
                    expect(urlName).to(equal("com.viacom"))
                    
                    let schemeArray = firstItem["CFBundleURLSchemes"] as! NSArray
                    let firstScheme = schemeArray[0] as! String
                    expect(firstScheme).to(equal("routerapp"))
                } else {
                    expect(0).to(equal(1))
                }
            }
        }
        
    }
}

