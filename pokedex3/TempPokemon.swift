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
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttak = 0
    var specialDefense = 0
    var speed = 0
    let sprite: URL
    let shiny: URL
    
    enum PokemonKeys: String, CodingKey{
        case id
        case name
        case types
        case stats
        case sprites
        
        // Necesary to match data with the json
        enum TypeDictionaryKeys: String, CodingKey{
            case type
            
            // Necesary to match data with the json
            enum TypeKeys: String, CodingKey{
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey{
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey{
                case name
            }
        }
        
        enum SpriteDictionaryKeys: String, CodingKey{
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    
    init(from decoder:Decoder)throws{
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd{
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name){
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttak = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "spacial-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("Never get here...")
            }
        }
        
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteDictionaryKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
}
