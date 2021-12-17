//
//  Model.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 02/11/2021.
//

import Foundation
import UIKit

struct User {
    let email : String
    let password : String
}

struct Registered {
    let user1 = User(email: "bujes@mail.com", password: "1234pass")
}

var misTracks : [Track] = []

var playlist : [String] = []

struct AudioCellModel {
    var delegate : CelDelegate
    var songName : String
    var love = false
    
    mutating func loved() {
        self.love = !love
    }
}

protocol CelDelegate{
    func updateState()
}

struct Track : Codable, Hashable {
    let title : String?
    let artist: String?
    let album: String?
    let genre : String?
    let songId : String?
    //let duration : Double?
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case artist
        case album
        case genre
        case songId = "song_id"
        
        //case duration
    }
    
//    enum MusicGenre: String, Codable {
//      case Rock
//      case Pop
//      case Jazz
//      case Folclore
//      case Vacio = ""
//    }
}

enum PlayerStates {
    case play
    case pause
    case next
    case previous
    
}










