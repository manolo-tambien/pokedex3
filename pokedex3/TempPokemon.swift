//
//  TempPokemon.swift
//  pokedex3
//
//  Created by Manolo on 15/02/24.
//

import Foundation

struct TempPokemon: Codable{
    let id: Int
    let name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttak: Int
    let specialDefense: Int
    let speed: Int
    let sprite: URL
    let shiny: URL
}
