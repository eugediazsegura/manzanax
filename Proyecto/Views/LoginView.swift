//
//  ViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 22/10/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel?
    var typeError: Int = 0
    
    @IBOutlet weak var username: UITextField?
    
    @IBOutlet weak var password: UITextField?
    
    @IBAction func `continue`(_ sender: Any) {
        var msgError = ""
        guard let userName = self.username?.text,
              let userPassword = self.password?.text,
              let autenticated = self.viewModel?.loginAccess(user: userName, password: userPassword, msgError: &msgError) else{
                  return
              }
        if autenticated {
            goToMainController()
        } else {
            username?.text = ""
            username?.becomeFirstResponder()
            password?.text = ""
            self.showMessage(msgError)
            username?.errorAnimated()
            password?.errorAnimated()
            
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        self.view?.startInController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username?.text = ""
        password?.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func goToMainController () {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    func bindViewModel() {
        viewModel = LoginViewModel()
        self.goToMainController()
    }
}


