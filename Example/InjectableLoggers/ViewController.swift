//
//  ViewController.swift
//  InjectableLoggers
//
//  Created by mclovink@me.com on 04/30/2018.
//  Copyright (c) 2018 mclovink@me.com. All rights reserved.
//

import UIKit
import InjectableLoggers

class ViewController: UIViewController {

    var logger: CanLogMessageAtLevel = Logger(settings: .verboseSettings)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logger.log(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logger.log(#function, at: Loglevel.verbose)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logger.log(#function, at: Loglevel.verbose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        logger.log(#function, at: Loglevel.warning)
    }
}

