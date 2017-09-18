//
//  UIView+setRadius.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/17/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
}
