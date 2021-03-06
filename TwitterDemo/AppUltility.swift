//
//  AppUltility.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/26/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

//Gradient button
func gradientForButton(button: UIButton) -> UIButton{
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = button.bounds
    let colors = [UIColor(red: 198.0/255.0, green: 53.0/255.0, blue: 50.0/255.0, alpha: 1.0).CGColor,
                  UIColor(red: 185.0/255.0, green: 40.0/255.0, blue: 105.0/255.0, alpha: 1).CGColor]
    
//    let colors = [UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1).CGColor,
//                  UIColor(red: 255.0/255.0, green: 242.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor,
//                  UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1).CGColor]
    
//    let colors = [UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1).CGColor,
//                  UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1).CGColor]
    
    gradient.colors = colors
    gradient.locations = [0, 0.5]
    gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    button.layer.insertSublayer(gradient, atIndex: 0)
    
    return button
}
class AppThemes: NSObject {
    static let themeColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1)
}
