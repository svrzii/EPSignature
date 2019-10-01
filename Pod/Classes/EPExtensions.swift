//
//  EPExtensions.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/01/16.
//
//

import Foundation

//MARK: - UIViewController Extensions

extension UIViewController {
    
    func showAlert(_ message: String) {
        showAlert(message, andTitle: "")
    }
    
    func showAlert(_ message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UIColor Extensions

extension UIColor {
    class func defaultTintColor() -> UIColor {
        return UIColor(red: (233/255), green: (159/255), blue: (94/255), alpha: 1.0)
    }
}

struct screen {
    static var rect: CGRect {
        if let bounds = UIApplication.shared.keyWindow?.bounds {
            return bounds
        }
        return UIScreen.main.bounds
    }
    static var width: CGFloat {
        if let width = UIApplication.shared.keyWindow?.bounds.width {
            return width
        }
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        if let height = UIApplication.shared.keyWindow?.bounds.height {
            return height
        }
        return UIScreen.main.bounds.height
    }
}
