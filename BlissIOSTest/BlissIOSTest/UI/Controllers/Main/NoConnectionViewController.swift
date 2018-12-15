//
//  NoConnectionViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 15/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class NoConnectionViewController: BasicViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func setupView() {
        lblTitle.text = NSLocalizedString("no_internet_connection", comment: "")
    }
    
    override func setupObservers() {
        
    }
}
