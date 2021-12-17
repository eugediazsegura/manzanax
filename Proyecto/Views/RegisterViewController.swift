//
//  RegisterViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 27/10/2021.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet var Background: UIView!
    
    @IBOutlet weak var signUp: UILabel!
    
    @IBOutlet weak var enterUsername: UILabel!
    
    @IBOutlet weak var socialMedia: UILabel!
    
    @IBOutlet weak var botonFace: UIButton!
    
    @IBOutlet weak var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Background.backgroundColor = UIColor(named: "Background")
        signUp.textColor = UIColor(named: "Titles")
        enterUsername.textColor = UIColor(named: "label")
        socialMedia.textColor = UIColor(named: "label")
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Facebook(_ sender: Any) {
        botonFace.backgroundColor = UIColor(named: "ColorButton")
    }
    @IBAction func register(_ sender: Any) {
        if let inputText = (self.input.text) {
            if inputText != "" {
                if inputText.count > 10 {
                    print("El usuario debe tener menos de 10 caracteres")
                }else{
                    print("inicio de sesión")
                }
            }else{
                print("usuario inválido")
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
