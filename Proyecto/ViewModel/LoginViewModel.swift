//
//  LoginViewModel.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 10/12/2021.
//

import Foundation

class LoginViewModel {
    
    var validator: ValidatorViewModel?
    
    func loginAccess(user: String?, password: String?, msgError: inout String)->Bool{
        validator = ValidatorViewModel()
        let userOK = self.validator?.validateEmail(user ?? "", &msgError)
        let passOK = self.validator?.validatePassword(password ?? "", &msgError)
        if userOK! && passOK! {
            guard let register = self.validator?.validateRegister(user!, password!, &msgError) else { return false }
            return register
        }
        return false
    }
    
}
