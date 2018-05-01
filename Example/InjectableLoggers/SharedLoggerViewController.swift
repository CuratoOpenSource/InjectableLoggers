//
//  ViewController.swift
//  InjectableLoggers
//
//  Created by mclovink@me.com on 04/30/2018.
//  Copyright (c) 2018 mclovink@me.com. All rights reserved.
//

import UIKit

class SharedLoggerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log("0️⃣", atLevel: .info)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logger.log("1️⃣", atLevel: .verbose)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logger.log("2️⃣", atLevel: .verbose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        logger.log("3️⃣", atLevel: .warning)
    }
}

