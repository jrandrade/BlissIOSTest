//
//  ChoiceTableViewCell.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 15/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChoice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupView()
    }
    
    func setupView() {
        lblChoice.layer.borderColor = StyleKit.mainColor.cgColor
        lblChoice.layer.borderWidth = 1
        lblChoice.textColor = StyleKit.mainColor
        lblChoice.layer.cornerRadius = 5
    }
    
    func setSelectedLayout() {
        if lblChoice.backgroundColor == .clear {
            lblChoice.backgroundColor = StyleKit.mainColor
            lblChoice.textColor = .white
        } else {
            lblChoice.backgroundColor = .clear
            lblChoice.textColor = StyleKit.mainColor
        }
    }
    
}
