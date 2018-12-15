//
//  ShareViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 15/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class ShareViewController: BasicViewController {

    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var vwSeparator: UIView!
    @IBOutlet weak var lblError: UILabel!
    
    var isDetail = false
    var id: Int? = nil
    var filter: String? = nil
    
    override func setupView() {
        title = NSLocalizedString("share", comment: "")
        btnShare.backgroundColor = StyleKit.mainColor
        btnShare.layer.cornerRadius = 10
        btnShare.setTitleColor(.white, for: .normal)
        btnShare.setTitle(NSLocalizedString("share", comment: ""), for: .normal)
        lblError.isHidden = true
    }
    
    
    @IBAction func share(_ sender: Any) {
        let questionManager = QuestionManager()
        guard let email = txtEmailAddress.text, !(email.isEmpty), email.isValidEmail else {
            lblError.isHidden = false
            vwSeparator.backgroundColor = .red
            return
        }
        lblError.isHidden = true
        vwSeparator.backgroundColor = StyleKit.mainColor.withAlphaComponent(0.6)
        showLoader()
    
        questionManager.share(isDetail: isDetail, id: id, filter: filter, destinationEmail: txtEmailAddress.text!) {[weak self] (success, error) in
            guard let strongSelf = self else {return}
            
            strongSelf.hideLoader()
            guard error == nil else {
                strongSelf.showErrorAlert()
                return
            }
            
            strongSelf.showSuccessAlert()
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("share_success", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: { [weak self]  action in
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("server_error", comment: ""), message: NSLocalizedString("server_error_description", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("try_again", comment: ""), style: UIAlertActionStyle.default, handler: { [weak self]  action in
            guard let strongSelf = self else {return}
            strongSelf.setupData()
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
