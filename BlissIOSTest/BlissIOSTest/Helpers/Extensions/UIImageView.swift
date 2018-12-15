//
//  UIImageView.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 15/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(withUrl imageUrl: String?, placeholder: UIImage) {
        
        self.image = nil
        self.af_cancelImageRequest()
        
        guard let _ = imageUrl else {
            return
        }
        
        if imageUrl!.characters.count > 0 {
            self.af_cancelImageRequest()
            self.af_setImage(withURL: URL(string: imageUrl!)!, placeholderImage: placeholder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
        }
        self.clipsToBounds = true
    }
}
