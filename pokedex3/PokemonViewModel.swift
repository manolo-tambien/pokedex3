//
//  PokemonViewModel.swift
//  pokedex3
//
//  Created by Manolo on 19/02/24.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    // As soon as this controller is created, this controller initialize
    init(controller:FetchController){
        self.controller = controller
        // Use Task to execute an async await block of code
        Task {
            await getPokemon()
        }
    }
    
    
    private func getPokemon() async {
        status = .fetching
        
        do{
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print("Pokemon have already been got. We good.")
                status = .success
                return
            }
            
            pokedex.sort{ $0.id < $1.id }
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.orginezeTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttak)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                try PersistenceController.shared.container.viewContext.save()
            }
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
