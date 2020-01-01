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
import Router

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let root = self.window?.rootViewController as! UINavigationController
        
        router.bind("/route/one") { (req) -> Void in
            let list: ViewController = storyboard.instantiateViewController(withIdentifier: "routeOneList") as! ViewController
            list.debugText = req.url.absoluteString
            root.pushViewController(list, animated: true)
        }
        
        router.bind("/route/one/:id") { (req) -> Void in
            let list: ViewController = storyboard.instantiateViewController(withIdentifier: "routeOneList") as! ViewController
            list.debugText = "deeplink from \(req.route.route)"
            
            let detail: ViewController = storyboard.instantiateViewController(withIdentifier: "routeOneDetail") as! ViewController
            detail.debugText = req.route.route
            detail.id = req.param("id")!
            
            root.pushViewController(list, animated: false)
            root.pushViewController(detail, animated: true)
        }
        
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return router.match(url) != nil
    }
    
    func application(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return application(app, handleOpen: url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return application(app, handleOpen: url)
    }

}

