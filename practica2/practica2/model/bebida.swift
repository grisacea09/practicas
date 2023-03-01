//
//  bebida.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 22/02/23.
//

import Foundation

struct drinks: Codable {
   
    let result: bebida
}

struct bebida: Codable {
    let directions: String
    let ingredients: String
    let name: String
    let img: String
    
}
