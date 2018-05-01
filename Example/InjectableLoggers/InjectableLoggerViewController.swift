//
//  ViewController.swift
//  InjectableLoggers
//
//  Created by mclovink@me.com on 04/30/2018.
//  Copyright (c) 2018 mclovink@me.com. All rights reserved.
//

import UIKit
import InjectableLoggers

class InjectableLoggerViewController: UIViewController {

    var logger: CanLogMessageAtLevel = SimpleLogger(settings: .verboseSettings)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log(#function, atLevel: .info)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logger.log(#function, atLevel: .verbose)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logger.log(#function, atLevel: .verbose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        logger.log(#function, atLevel: .warning)
    }
}

