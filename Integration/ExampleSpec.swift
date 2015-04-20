//
//  ExampleSpec.swift
//  RouterExample
//
//  Created by Martino Buffolino on 4/20/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit
import Quick
import Nimble

class ExampleSpec: QuickSpec {
    
    override func spec() {
        
        describe("plist config") {
            
            it("deeplink scheme is in plist") {
                var plist: NSDictionary?
                if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
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

