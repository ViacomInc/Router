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

public class Route {
    
    static let routeParameterPattern = ":[a-zA-Z0-9-_]+"
    static let urlParameterPattern = "([^/]+)"
    
    let routeParameter: NSRegularExpression = try! NSRegularExpression(pattern: routeParameterPattern, options: .CaseInsensitive)
    let urlParameter: NSRegularExpression = try! NSRegularExpression(pattern: urlParameterPattern, options: .CaseInsensitive)
    
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
    
        - returns: string representation of the regex
    */
    func regex() -> String? {
        let _route = "^\(route)/?$"
        var _routeRegex: NSString = _route
        let matches = routeParameter.matchesInString(_route, options: [],
            range: NSMakeRange(0, _route.characters.count))

        // range offset when replacing :params
        var offset = 0
        
        for match in matches as [NSTextCheckingResult] {
            
            var matchWithOffset: NSRange = match.range
            if offset != 0 {
                matchWithOffset = NSMakeRange(matchWithOffset.location + offset, matchWithOffset.length)
            }
            
            // route param (ie. :id)
            let urlParam = _routeRegex.substringWithRange(matchWithOffset)
            
            // route param with ':' (ie. id)
            let name = (urlParam as NSString).substringFromIndex(1)

            // url params should be unique
            if urlParamKeys.contains(name) {
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
            offset += Route.urlParameterPattern.characters.count - urlParam.characters.count
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



