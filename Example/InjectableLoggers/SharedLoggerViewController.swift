//
//  Copyright © 2020 Curato Research BV. All rights reserved.
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

