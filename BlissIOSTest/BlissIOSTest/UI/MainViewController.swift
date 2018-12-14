//
//  MainViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class MainViewController: BasicViewController {
    
    override func setupView() {
        
    }
    
    override func setupData() {
        let serverHealthManager = ServerHealthManager()
        self.showLoader()
        
        serverHealthManager.getServerHealth {[weak self] (health, error) in
            
            guard let strongSelf = self else {return}
            
            strongSelf.hideLoader()
            
            guard health == true else {
                return
            }
            strongSelf.createAlert()
        }
    }
    
    private func createAlert() {
        let alert = UIAlertController(title: NSLocalizedString("server_error", comment: ""), message: NSLocalizedString("server_error_description", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("try_again", comment: ""), style: UIAlertActionStyle.default, handler: { [weak self]  action in
            guard let strongSelf = self else {return}
            strongSelf.setupData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
