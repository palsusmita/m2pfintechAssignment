//
//  UIImageView.swift
//  m2pfintechAssignment
//
//  Created by susmita on 14/07/24.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: URL) {
        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.image = image
        }
    }
}
