//
//  UIImage+colored.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/13/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//
import UIKit
import Foundation

extension UIImage {
    
    func colored(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
