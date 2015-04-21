//
//  RootViewController.swift
//  RouterExample
//
//  Created by Martino Buffolino on 4/21/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit

class MyRootViewController: UIViewController {
    
    let scheme = "routerapp://"
    
    func doDeeplink(path: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "\(scheme)\(path)")!)
    }

    @IBAction func onListClick(sender: AnyObject) {
        doDeeplink("route/one")
    }
    
    @IBAction func onDetailClick(sender: AnyObject) {
        doDeeplink("route/one/testing1234")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
