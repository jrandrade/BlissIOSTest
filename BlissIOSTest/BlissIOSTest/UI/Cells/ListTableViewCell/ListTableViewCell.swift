//
//  ListTableViewCell.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
protocol ListTableViewCellProtocol: class {
    func share(index: Int)
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    weak var delegate: ListTableViewCellProtocol? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    

    @IBAction func share(_ sender: Any) {
        delegate?.share(index: tag)
    }
    
    
}
