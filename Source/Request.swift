//
//  Request.swift
//  MPSurfer
//
//  Created by Martino Buffolino on 4/15/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit

public class Request {
    
    internal var route: Route!
    internal var urlParams: [String: String] = [String: String]()
    internal var queryParams: [String: String]?
    
    init(aRoute: Route, urlParams: [NSURLQueryItem], queryParams: [NSURLQueryItem]?) {
        self.route = aRoute
        
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
    
        :param: name Key of the param
        :returns: value of the the param
    */
    func param(name: String) -> String? {
        return self.urlParams[name]
    }
    
    /**
        Acessing query strings params in the route, ie q from /video?q=asdf
    
        :param: name Key of the param
        :returns: value of the the param
    */
    func query(name: String) -> String? {
        if let queryParams = self.queryParams {
            return queryParams[name]
        }
        
        return nil
    }
    
}
