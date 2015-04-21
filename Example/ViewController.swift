//
//  ViewController.swift
//  RouterExample
//
//  Created by Martino Buffolino on 4/20/15.
//  Copyright (c) 2015 Viacom Media Network. All rights reserved.
//

import UIKit
import Router

class ViewController: UIViewController {
    
    @IBOutlet weak var debugLabel: UILabel!
    var debugText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let debugText = debugText {
            debugLabel.text = debugText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

