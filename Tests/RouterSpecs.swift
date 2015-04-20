//
//  RouterSpecs.swift
//  MPSurfer
//
//  Created by Martino Buffolino on 4/9/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit
import Quick
import Nimble

class RouterSpecs: QuickSpec {
    
    override func spec() {
        
        describe("Route") {
            
            describe(".regex") {
                
                it("converts /video/:id to regex /video/([^/]+)/?") {
                    var route: Route = Route(aRoute: "/video/:id")
                    expect(route.routePattern).to(equal("^/video/([^/]+)/?$"))
                }
                
                it("converts /shows/:showId/video/:id to regex /shows/([^/]+)/video/([^/]+)/?") {
                    var route: Route = Route(aRoute: "/shows/:showId/video/:id")
                    expect(route.routePattern).to(equal("^/shows/([^/]+)/video/([^/]+)/?$"))
                }
                
                it("converts routes with many params to a regex pattern") {
                    var route: Route = Route(aRoute: "/a/:a/b/:b/c/:c/d/:d/e/:e/f/:f")
                    expect(route.routePattern).to(equal("^/a/([^/]+)/b/([^/]+)/c/([^/]+)/d/([^/]+)/e/([^/]+)/f/([^/]+)/?$"))
                }
                
                it("converts routes with many variable length params to a regex pattern") {
                    var route: Route = Route(aRoute: "/a/:abc/b/:bcdef/third/:cx/d/:d123/efgh/:e987654/:lastOne")
                    expect(route.routePattern).to(equal("^/a/([^/]+)/b/([^/]+)/third/([^/]+)/d/([^/]+)/efgh/([^/]+)/([^/]+)/?$"))
                }
                
                it("converts non parameterized routes to a regex pattern") {
                    var route: Route = Route(aRoute: "/shows")
                    expect(route.routePattern).to(equal("^/shows/?$"))
                }
                
                it("raises exception with identical url params in route") {
                    expect(Route(aRoute: "/shows/:id/:id")).to(raiseException(named: "Identical route params"))
                }
                
            }
            
        }
        
        describe("Router") {
            
            describe(".match") {
                let route = "/video/:id"
                var myRouter: Router?
                
                beforeEach() {
                    myRouter = Router()
                }
                
                it("allows alpha numeric and _, - characters in params") {
                    let example = NSURL(string: "/video/123-asdf_foo-bar?q=123-_-")!
                    myRouter?.bind(route) {
                        (req) in
                        expect(req.param("id")!).to(equal("123-asdf_foo-bar"))
                        expect(req.query("q")).to(equal("123-_-"))
                    }
                    
                    var matched: Route = myRouter!.match(example)!
                    expect(matched.route).to(equal(route))
                }
                
                it("returns 1234 as :id in /video/1234") {
                    let example = NSURL(string: "/video/1234")!
                    myRouter?.bind(route) {
                        (req) in
                        expect(req.param("id")!).to(equal("1234"))
                        expect(req.query("id")).to(beNil())
                    }
                    
                    var matched: Route = myRouter!.match(example)!
                    expect(matched.route).to(equal(route))
                }
                
                it("handles routes with many params") {
                    let example = NSURL(string: "/a/1/b/22/third/333/d/4444/efgh/55/6?q=asdf&fq=-alias")!
                    let aRoute = "/a/:abc/b/:bcdef/third/:cx/d/:d123/efgh/:e987654/:lastOne"
                    
                    myRouter?.bind(aRoute) {
                        (req) in
                        expect(req.param("abc")!).to(equal("1"))
                        expect(req.param("bcdef")!).to(equal("22"))
                        expect(req.param("cx")!).to(equal("333"))
                        expect(req.param("d123")!).to(equal("4444"))
                        expect(req.param("e987654")!).to(equal("55"))
                        expect(req.param("lastOne")!).to(equal("6"))
                        expect(req.query("q")!).to(equal("asdf"))
                        expect(req.query("fq")!).to(equal("-alias"))
                    }
                    
                    var matched: Route = myRouter!.match(example)!
                    expect(matched.route).to(equal(aRoute))
                }
                
                it("does not match routes with malformed query strings") {
                    let example = NSURL(string: "/video/123/&q=asdf")!
                    
                    myRouter?.bind(route) {
                        (req) in
                        expect(req.query("q")).to(beNil())
                    }

                    expect(myRouter!.match(example)).to(beNil())
                }
                
                it("accepts query strings with '?&' sequence") {
                    myRouter?.bind(route) {
                        (req) in
                        expect(req.param("id")!).to(equal("1234"))
                        expect(req.query("q")!).to(equal("asdf"))
                    }
                    
                    var matched: Route = myRouter!.match(NSURL(string: "/video/1234/?&q=asdf")!)!
                    expect(matched.route).to(equal(route))
                    
                    matched = myRouter!.match(NSURL(string: "/video/1234?&q=asdf")!)!
                    expect(matched.route).to(equal(route))
                }
                
                it("matches routes at the start of the string, not suffix") {
                    myRouter?.bind(route) {
                        (req) in
                        expect(0).to(equal(1))
                    }
                    
                    var matched: Route? = myRouter!.match(NSURL(string: "/shows/1234/video/1234")!)
                    expect(matched).to(beNil())
                }
                
                it("doesn't mix url param id with query param id") {
                    let example = NSURL(string: "/video/1234?id=asdf")!
                    myRouter?.bind(route) {
                        (req) in
                        expect(req.param("id")!).to(equal("1234"))
                        expect(req.query("id")).to(equal("asdf"))
                    }
                    
                    var matched: Route = myRouter!.match(example)!
                    expect(matched.route).to(equal(route))
                }
                
                it("matches specific routes before general when binded first") {
                    myRouter?.bind("/video/jersey-shore") { (req) in expect(0).to(equal(0)) }
                    myRouter?.bind("/video/:id") { (req) in expect(0).to(equal(1)) }
                    
                    if let myRoute = myRouter?.match(NSURL(string: "/video/jersey-shore")!) {
                        expect(myRoute.route).to(equal("/video/jersey-shore"))
                    } else {
                        expect(0).to(equal(1))
                    }
                }
                
                it("matches general routes before specific when binded first") {
                    myRouter?.bind("/video/:id") { (req) in expect(0).to(equal(0)) }
                    myRouter?.bind("/video/jersey-shore") { (req) in expect(0).to(equal(1)) }
                    
                    if let myRoute = myRouter?.match(NSURL(string: "/video/jersey-shore")!) {
                        expect(myRoute.route).to(equal("/video/:id"))
                    } else {
                        expect(0).to(equal(1))
                    }
                }
                
                it("returns nil when no route is matched") {
                    myRouter?.bind(route) {
                        (req) in
                        expect(0).to(equal(1))
                    }
                    
                    if let myRoute = myRouter?.match(NSURL(string: "/shows/1234")!) {
                        expect(0).to(equal(1))
                    } else {
                        expect(0).to(equal(0))
                    }
                }
                
            }
        }
        
    }
}