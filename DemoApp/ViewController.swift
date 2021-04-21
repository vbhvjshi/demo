//
//  ViewController.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 11/04/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    var isValidEmailId : Bool {
        let emailRegExpression = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegExpression)
        return emailTest.evaluate(with: self)
    }
}

extension UIView {
    func setCustomCorners(_ radius: CGFloat?, _ borderWidth: CGFloat?, _ color: UIColor?) {
        self.layer.cornerRadius = radius ?? 0.0
        self.layer.borderWidth = borderWidth ?? 0.0
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
    }
}


