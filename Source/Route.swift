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

open class Route {
    
    enum Pattern: String {
        case RouteParam = ":[a-zA-Z0-9-_]+"
        case UrlParam = "([^/]+)"
    }
    
    enum RegexResult: Error, CustomDebugStringConvertible {
        case success(regex: String)
        case duplicateRouteParamError(route: String, urlParam: String)
        
        var debugDescription: String {
            switch self {
            case .success(let regex):
                return "successfully parsed to \(regex)"
            case .duplicateRouteParamError(let route, let urlParam):
                return "duplicate url param \(urlParam) was found in \(route)"
            }
        }
    }
    
    let routeParameter = try! NSRegularExpression(pattern: .RouteParam, options: .caseInsensitive)
    let urlParameter = try! NSRegularExpression(pattern: .UrlParam, options: .caseInsensitive)
    
    // parameterized route, ie: /video/:id
    open let route: String
    
    // route in its regular expression pattern, ie: /video/([^/]+)
    var routePattern: String?
    
    // url params found in route
    var urlParamKeys = [String]()
    
    init(aRoute: String) throws {
        route = aRoute
        switch regex() {
        case .success(let regex):
            routePattern = regex
        case .duplicateRouteParamError(let route, let urlParam):
            throw RegexResult.duplicateRouteParamError(route: route, urlParam: urlParam)
        }
    }
    
    /**
        Forms a regex pattern of the route
    
        - returns: string representation of the regex
    */
    func regex() -> RegexResult {
        let _route = "^\(route)/?$"
        var _routeRegex = NSString(string: _route)
        let matches = routeParameter.matches(in: _route, options: [],
            range: NSMakeRange(0, _route.characters.count))

        // range offset when replacing :params
        var offset = 0
        
        for match in matches as [NSTextCheckingResult] {
            
            var matchWithOffset = match.range
            if offset != 0 {
                matchWithOffset = NSMakeRange(matchWithOffset.location + offset, matchWithOffset.length)
            }
            
            // route param (ie. :id)
            let urlParam = _routeRegex.substring(with: matchWithOffset)
            
            // route param with ':' (ie. id)
            let name = (urlParam as NSString).substring(from: 1)

            // url params should be unique
            if urlParamKeys.contains(name) {
                return .duplicateRouteParamError(route: route, urlParam: name)
            } else {
                urlParamKeys.append(name)
            }
            
            // replace :params with regex
            _routeRegex = _routeRegex.replacingOccurrences(of: urlParam,
                with: Pattern.UrlParam.rawValue, options: NSString.CompareOptions.literal, range: matchWithOffset) as NSString
            
            // update offset
            offset += Pattern.UrlParam.rawValue.characters.count - urlParam.characters.count
        }
            
        return .success(regex: _routeRegex as String)
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

// MARK: NSRegularExpression

extension NSRegularExpression {
    
    convenience init(pattern: Route.Pattern, options: NSRegularExpression.Options) throws {
        try self.init(pattern: pattern.rawValue, options: options)
    }
    
}
