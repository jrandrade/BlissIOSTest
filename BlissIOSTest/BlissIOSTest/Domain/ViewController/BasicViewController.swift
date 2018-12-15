//
//  BasicViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class BasicViewController: UIViewController {
    var loadNotification : MBProgressHUD?
    var noConnectionViewController: NoConnectionViewController! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadNibs()
        setupObservers()
        setupData()
         NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusDidChange), name: Config.notifications.network, object: nil)
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

    
    func setNoConnectionPage(isDetail: Bool = false) {
        if noConnectionViewController != nil {
            noConnectionViewController?.view.removeFromSuperview()
        }
        noConnectionViewController = NoConnectionViewController.instantiate(fromStoryboardName: Config.storyboard.main) as! NoConnectionViewController
        
        noConnectionViewController.view.frame = view.bounds
        
        self.addChildViewController(noConnectionViewController!)
        view.addSubview(noConnectionViewController!.view)
        noConnectionViewController?.didMove(toParentViewController: self)
        view.bringSubview(toFront: noConnectionViewController.view)
    }
    
    @objc func networkStatusDidChange() {
        if !NetworkReachabilityManager()!.isReachable {
            setNoConnectionPage()
            return
        }else {
            if noConnectionViewController != nil {
                
                UIView.transition(with: view, duration: 0.4, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.noConnectionViewController?.view.alpha = 0
                    
                }, completion: { (b) in
                    
                    self.noConnectionViewController?.view.removeFromSuperview()
                    
                })
            }
        }
        setupData()
    }

    
    static func instantiate(fromStoryboardName: String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: fromStoryboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
    
    static func instantiateNavigation(fromStoryboardName name: String) -> UINavigationController {
        
        return UINavigationController(rootViewController: self.instantiate(fromStoryboardName: name))
    }
    
}
