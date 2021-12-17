//
//  Extension.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 15/12/2021.
//

import Foundation
import UIKit

extension String {
    func isValidEmail(_ email: String, _ msgError: inout String )->Bool{
        let patron = "[\\w|-]+@\\w{3,}(\\.\\w{2,5}){1,2}"
        let regExp = try! NSRegularExpression(pattern: patron, options: [])
        let coincidencias = regExp.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
            if coincidencias.count != 1 {
                msgError = "El nombre de usuario debe ser un correo válido"
                return false
            }
        return true
    }
}

extension UIViewController {
    
    func showMessage(_ mensaje:String) {
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func popUp (_ titulo: String, _ mensaje: String){
        let alert  = UIAlertController (title: titulo, message: mensaje, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func startInController() {
        self.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.2, animations: {self.alpha = 1
            
        })
    }
}

extension UITextField {
    func errorAnimated() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = 4
        animation.duration = 0.4/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [10, -10]
        self.layer.add(animation, forKey: "shake")
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
