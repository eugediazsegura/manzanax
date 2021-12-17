//
//  Validator.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 17/11/2021.
//

import Foundation

class ValidatorViewModel {
    var usernameOK = false
    var passwordOK = false
    let model : Registered = Registered()
    
    
    func validate(_ input : String, _ campo: String, _ msgError: inout String)->Bool{
        var isValid = false
        if input != "" {
            if input.count > 15 {
                msgError = "\(campo) deben tener menos de 15 caracteres"
                return isValid
            }
        } else {
            msgError = "\(campo) es un campo requerido y no puede estar vacio"
            return isValid
        }
        isValid = true
        return isValid
    }
    

    func validateEmail(_ email: String, _ msgError: inout String) -> Bool{
        
        let validated = validate(email, "email", &msgError)
        
        if !validated {
            return usernameOK
        }
        
        let arrayString = Array(email)
        usernameOK = arrayString.contains("@")
        if !usernameOK {
            msgError = "El nombre de usuario debe contener un @"
            return usernameOK
        }
        
        return email.isValidEmail(email, &msgError)

    }
    
    func validatePassword (_ password: String, _ msgError: inout String) -> Bool{
        let validated = validate(password, "password", &msgError)
        
        if !validated {
            return passwordOK
        }
        passwordOK = true
        return passwordOK
    }
    
    
    func validateRegister(_ email: String, _ password: String,_ msgError: inout String) ->Bool{
        if model.user1.email == email && model.user1.password == password {
            return true
        }
        msgError = "Usuario o contraseña incorrectos"
        return false
    }
}
