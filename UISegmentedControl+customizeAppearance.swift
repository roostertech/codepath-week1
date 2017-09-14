//
//  UISegmentedControl+customizeAppearance.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/13/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//
import UIKit
import Foundation

extension UISegmentedControl {
    
    func customizeAppearance(for height: Int) {
        
        setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.white], for:.normal)
        setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.white], for:.selected)
        setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: height)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: height)), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: UIColor.init(red: 0/255.0, green: 0.0, blue: 30/255.0, alpha: 0.5), size: CGSize(width: 1, height: height)), for: .selected, barMetrics: .default);
        
        for  borderview in subviews {
            let upperBorder: CALayer = CALayer()
            upperBorder.backgroundColor = UIColor.init(red: 215/255.0, green: 0.0, blue: 30/255.0, alpha: 1.0).cgColor
            upperBorder.frame = CGRect(x: 0, y: borderview.frame.size.height-1, width: borderview.frame.size.width, height: 1)
            borderview.layer.addSublayer(upperBorder)
        }
        
    }
}
