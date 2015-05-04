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

public class Router {
    
    public typealias RouteHandler = (req: Request) -> Void
    private var orderedRoutes: [Route] = [Route]()
    private var routes: [Route: RouteHandler] = [Route: RouteHandler]()
    
    public init() {}
    
    /**
        Binds a route to a router
    
        :param: aRoute A string reprsentation of the route. It can include url params, for example id in /video/:id
        :param: callback Triggered when a route is matched
    */
    public func bind(aRoute: String, callback: RouteHandler) {
        let route = Route(aRoute: aRoute)
        orderedRoutes.append(route)
        routes[route] = callback
    }
    
    /**
        Matches an incoming NSURL to a route present in the router. Returns nil if none are matched.
    
        :param: url An NSURL of an incoming request to the router
        :returns: The matched route or nil
    */
    public func match(url: NSURL) -> Route? {
        
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
        for route in orderedRoutes {
            
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
