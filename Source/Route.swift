//
//  Route.swift
//  MPSurfer
//
//  Created by Martino Buffolino on 4/13/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit

public class Route {
    
    static let routeParameterPattern = ":[a-zA-Z0-9-_]+"
    static let urlParameterPattern = "([^/]+)"
    
    let routeParameter: NSRegularExpression = NSRegularExpression(pattern: routeParameterPattern, options: .CaseInsensitive, error: nil)!
    let urlParameter: NSRegularExpression = NSRegularExpression(pattern: urlParameterPattern, options: .CaseInsensitive, error: nil)!
    
    // parameterized route, ie: /video/:id
    public var route: String! {
        didSet {
            if let regex = regex() {
                routePattern = regex
            }
        }
    }
    
    // route in its regular expression pattern, ie: /video/([^/]+)
    var routePattern: String!
    
    // url params found in route
    var urlParamKeys: [String] = [String]()
    
    init(aRoute: String) {
        setupRoute(aRoute)
    }
    
    private func setupRoute(aRoute: String) {
        route = aRoute
    }
    
    /**
        Forms a regex pattern of the route
    
        :returns: string representation of the regex
    */
    func regex() -> String? {
        var _route = "^\(route)/?$"
        var _routeRegex: NSString = _route
        let matches = routeParameter.matchesInString(_route, options: .allZeros,
            range: NSMakeRange(0, count(_route)))

        // range offset when replacing :params
        var offset = 0
        
        for match in matches as! [NSTextCheckingResult] {
            
            var matchWithOffset: NSRange = match.range
            if offset != 0 {
                matchWithOffset = NSMakeRange(matchWithOffset.location + offset, matchWithOffset.length)
            }
            
            // route param (ie. :id)
            let urlParam = _routeRegex.substringWithRange(matchWithOffset)
            
            // route param with ':' (ie. id)
            let name = (urlParam as NSString).substringFromIndex(1)

            // url params should be unique
            if contains(urlParamKeys, name) {
                let e: NSException = NSException(name:"Identical route params",
                    reason: "param \(name) was already found in url, \(route)", userInfo: nil)
                e.raise()
            } else {
                urlParamKeys.append(name)
            }
            
            // replace :params with regex
            _routeRegex = _routeRegex.stringByReplacingOccurrencesOfString(urlParam,
                withString: Route.urlParameterPattern, options: NSStringCompareOptions.LiteralSearch, range: matchWithOffset)
            
            // update offset
            offset += count(Route.urlParameterPattern) - count(urlParam)
        }
            
        return _routeRegex as String
    }
}

// MARK: Hashable

extension Route: Hashable {
    public var hashValue: Int {
        return self.route.hashValue
    }
    
}

// MARK: Equatable

extension Route: Equatable {}

public func ==(lhs: Route, rhs: Route) -> Bool {
    return lhs.route == rhs.route
}



