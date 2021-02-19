//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/3.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    
}







