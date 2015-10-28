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

public class Request {
    
    private var _route: Route!
    
    public var route: Route! {
        get { return _route }
    }
    
    private var urlParams: [String: String] = [String: String]()
    private var queryParams: [String: String]?
    
    public init(aRoute: Route, urlParams: [NSURLQueryItem], queryParams: [NSURLQueryItem]?) {
        self._route = aRoute
        
        for param in urlParams {
            if let value = param.value {
                self.urlParams[param.name] = value
            }
        }
        
        if let queryParams = queryParams {
            self.queryParams = [String: String]()
            for param in queryParams {
                if let value = param.value {
                    self.queryParams![param.name] = value
                }
            }
        }
    }
    
    /**
        Acessing url params in the route, ie. id from /video/:id
    
        - parameter name: Key of the param
        - returns: value of the the param
    */
    public func param(name: String) -> String? {
        return self.urlParams[name]
    }
    
    /**
        Acessing query strings params in the route, ie q from /video?q=asdf
    
        - parameter name: Key of the param
        - returns: value of the the param
    */
    public func query(name: String) -> String? {
        if let queryParams = self.queryParams {
            return queryParams[name]
        }
        
        return nil
    }
    
}
