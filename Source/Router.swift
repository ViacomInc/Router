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

public typealias RouteHandler = (req: Request) -> Void

public class Router {
    
    private var orderedRoutes = [Route]()
    private var routes = [Route: RouteHandler]()
    
    public init() {}
    /**
        Binds a route to a router
    
        - parameter aRoute: A string reprsentation of the route. It can include url params, for example id in /video/:id
        - parameter callback: Triggered when a route is matched
    */
    public func bind(aRoute: String, callback: RouteHandler) {
        do {
            let route = try Route(aRoute: aRoute)
            orderedRoutes.append(route)
            routes[route] = callback
        } catch let error as Route.RegexResult {
            print(error.debugDescription)
        } catch {
            fatalError("[\(aRoute)] unknown bind error")
        }
    }
    
    /**
        Matches an incoming NSURL to a route present in the router. Returns nil if none are matched.
    
        - parameter url: An NSURL of an incoming request to the router
        - returns: The matched route or nil
    */
    public func match(url: NSURL) -> Route? {
        
        guard let routeComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        // form the host/path url
        let host = routeComponents.host.flatMap({"/\($0)"}) ?? ""
        let path = routeComponents.path.flatMap({$0}) ?? ""
        let routeToMatch = "\(host)\(path)"
        let queryParams = routeComponents.queryItems
        var urlParams = [NSURLQueryItem]()
        
        // match the route!
        for route in orderedRoutes {
            guard let pattern = route.routePattern else {
                continue
            }
              
            var regex: NSRegularExpression
              
            do {
                regex = try NSRegularExpression(pattern: pattern,
                options: .CaseInsensitive)
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
              
            let matches = regex.matchesInString(routeToMatch, options: [],
                range: NSMakeRange(0, routeToMatch.characters.count))
                    
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
                if let callback = routes[route] {
                    callback(req: Request(aRoute: route, urlParams: urlParams, queryParams: queryParams))
                }
                        
                // return route that was matched
                return route
            }
        }
        
        // nothing matched
        return nil
    }
    
}
