//
//  UIView-Movieator.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 21/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

extension UIView {
    class func autolayoutView() -> Self {
        let instance = self.init()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }
    
    func autolayoutView() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
