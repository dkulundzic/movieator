//
//  UIAlertControllerExtension-Movieator.swift
//  Movieator
//
//  Created by Matej Korman on 30/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func generic(title: String?,
                        message: String? = "",
                        preferredStyle: UIAlertControllerStyle = .alert,
                        actions: [UIAlertAction] = [],
                        cancelTitle: String = "Cancel") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { action in
            alertController.addAction(action)
        }
        if !actions.contains { $0.style == .cancel } {
            alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        }
        return alertController
    }
    
    func present(on viewController: UIViewController, animated: Bool = true) {
        viewController.present(self, animated: animated)
    }
}
