//
//  ExamplesViewController.swift
//  InjectableLoggers_Example
//
//  Created by Menno on 09/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ExamplesViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let cell = sender as? UITableViewCell else { return }
        
        segue.destination.title = cell.textLabel?.text
    }
}
