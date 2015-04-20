//
//  Router.swift
//  MPSurfer
//
//  Created by Martino Buffolino on 4/13/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit

public class Router {
    
    typealias routeHandler = (req: Request) -> Void
    internal var routes: [Route: routeHandler] = [Route: routeHandler]()
    
    public init() {}
    
    /**
        Binds a route to a router
    
        :param: aRoute A string reprsentation of the route. It can include url params, for example id in /video/:id
        :param: callback Triggered when a route is matched
    */
    func bind(aRoute: String, callback: routeHandler) {
        let route = Route(aRoute: aRoute)
        routes[route] = callback
    }
    
    /**
        Matches an incoming NSURL to a route present in the router. Returns nil if none are matched.
    
        :param: url An NSURL of an incoming request to the router
        :returns: The matched route or nil
    */
    func match(url: NSURL) -> Route? {
        
        var routeComponents: NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!

        // form the host/path url
        var routeToMatch = ""
        if let host = routeComponents.host {
            routeToMatch += "/\(host)"
        }
        if let path = routeComponents.path {
            routeToMatch += "\(path)"
        }
        
        var queryParams: [NSURLQueryItem]? = routeComponents.queryItems as? [NSURLQueryItem]
        var urlParams: [NSURLQueryItem] = [NSURLQueryItem]()
        
        // match the route!
        for (route, handler) in routes {
            
            if let pattern = route.routePattern, regex = NSRegularExpression(pattern: pattern,
                options: .CaseInsensitive, error: nil) {
                
                let matches: [NSTextCheckingResult] = regex.matchesInString(routeToMatch,
                    options: .allZeros, range: NSMakeRange(0, count(routeToMatch))) as! [NSTextCheckingResult]
                    
                // check if routeToMatch has matched
                if matches.count > 0 {
                    let match = matches[0]
                        
                    // gather url params
                    for i in 1 ..< match.numberOfRanges {
                        let name = route.urlParamKeys[i-1]
                        let value = (routeToMatch as NSString).substringWithRange(match.rangeAtIndex(i))
                        urlParams.append(NSURLQueryItem(name: name, value: value))
                    }
                        
                    // fire callback
                    routes[route]!(req: Request(aRoute: route, urlParams: urlParams, queryParams: queryParams))
                        
                    //return route that was matched
                    return route
                }
            }
        }
        
        // nothing matched
        return nil
        
    }
    
}
