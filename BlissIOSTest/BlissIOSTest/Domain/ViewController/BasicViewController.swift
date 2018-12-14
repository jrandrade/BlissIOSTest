//
//  BasicViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import MBProgressHUD

class BasicViewController: UIViewController {
    var loadNotification : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadNibs()
        setupObservers()
        setupData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        preconditionFailure("This method must be overridden")
    }
    
    func loadNibs() {
        
    }
    
    func setupData() {
        
        setupData(fromPullToRefresh: false)
    }
    
    func setupData(fromPullToRefresh: Bool = false) {
        
    }
    
    func setupObservers() {
        
    }
    
    func showLoader() {
        if loadNotification != nil {
            loadNotification?.hide(animated: true)
            loadNotification = nil
        }
        loadNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.bezelView.color = StyleKit.greensmoked
        //hud.contentColor = StyleKit.green
    }
    
    func hideLoader() {
        loadNotification?.hide(animated: true)
    }

    static func instantiate(fromStoryboardName: String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: fromStoryboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
    
    static func instantiateNavigation(fromStoryboardName name: String) -> UINavigationController {
        
        return UINavigationController(rootViewController: self.instantiate(fromStoryboardName: name))
    }
    
}
