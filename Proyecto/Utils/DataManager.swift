//
//  DataManager.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 28/11/2021.
//

import Foundation

class DataManager {
    
    static func cancionesPorGenero (canciones : [Track]) -> [Track]{
       return canciones.filter{$0.artist != ""}
    
    }
}
